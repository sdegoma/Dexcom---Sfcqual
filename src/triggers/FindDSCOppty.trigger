trigger FindDSCOppty on Opportunity (after insert,after update)
{
  List<PartnerNetworkRecordConnection> recordConns = new List<PartnerNetworkRecordConnection>();
  List<Opportunity> opports = new List<Opportunity>();
  Set<Id> OpptyRecIds = new Set<Id>();
  Set<Id> LocalRecIds = new Set<Id>();
  Set<Id> LocalRecIds1 = new Set<Id>();
  List<Opportunity> OppListSent = new List<Opportunity>();
  List<Opportunity> OppListSent1 = new List<Opportunity>();
  if(Recursive1.firstrun){
                
             for(Opportunity opp: Trigger.new){
             OpptyRecIds.add(opp.Id);
             }  
              If(OpptyRecIds.size()>0)
                recordConns = [select Id, Status, ConnectionId, LocalRecordId from PartnerNetworkRecordConnection where LocalRecordId in :OpptyRecIds];
             If(recordConns.size()>0)
             {
                for(PartnerNetworkRecordConnection recordConn : recordConns)
                {             
                   if(recordConn.Status.equalsignorecase('sent'))
                   { 
                          LocalRecIds.add(recordConn.LocalRecordId);
                          System.debug('Record ='+recordConn);
                   }
                   //if(recordConn.Status.equalsignorecase('Inactive') || recordConn.Status.equalsignorecase('deleted'))
                   if(recordConn.Status.equalsignorecase('Inactive') || recordConn.Status.equalsignorecase('deleted') || recordConn.Status.equalsignorecase('converted'))
                   { 
                          LocalRecIds1.add(recordConn.LocalRecordId);
                          System.debug('Record ='+recordConn);
                   }
                }
             }
OppListSent = [select Id,Received_Connection_Name__c from Opportunity where Id in : LocalRecIds AND Received_Connection_Name__c = NULL];
if(OppListSent.size()>0){
     for(Opportunity Opp: OppListSent){
                Opp.Received_Connection_Name__c = 'DSC';
                system.debug('Opp.Received_ConnectionName__c'+Opp.Received_Connection_Name__c);
               
     }
} 
OppListSent1 = [select Id,Received_Connection_Name__c from Opportunity where Id in : LocalRecIds1 AND Received_Connection_Name__c != NULL];
if(OppListSent1.size()>0){
     for(Opportunity Opp: OppListSent1){
                Opp.Received_Connection_Name__c = '';
                system.debug('Opp.Received_ConnectionName__c'+Opp.Received_Connection_Name__c);
               
     }
} 

try{
If(OppListsent.size()>0)
update OppListSent;
If(OppListsent1.size()>0)
update OppListSent1;
}

catch(Exception e) {System.debug('FindDSCOppty Exception'+e.getMessage());}
}
Recursive1.firstrun=false;  
}