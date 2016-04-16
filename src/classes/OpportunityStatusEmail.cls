public class OpportunityStatusEmail {   
public static void OppStatusEmail(List<Opportunity> Opp,Map <Id,Opportunity> OppOldMap,Map<ID,Opportunity> OppNewMap ) {
        String taskSubject = '';  //To Dynamically set Task Subject
        String taskComments= '';    //To Dynamically set Task Comments
        id OWDAddress;
        String customerEmailID = '';
        final string name2 = 'Opp flipped to 4.2 AS Needs docs or 4.3 Needs Docs'; 
        final string name3 = 'Opp flipped to 5.1  Auth Submitted';
        final string name4 = 'Opp flipped to 5.3A Authorized';
        final string name5 = 'Opp flipped to 6.2 Insurance Quote Pending';
        //Get the template id for the template to be used
        Id templateId  = [select id, name from EmailTemplate where developername = : 'AutoEmailVFTemplate'].id;
        Id templateId1 = [select id, name from EmailTemplate where name = :name2].id;  
        Id templateId2 = [select id, name from EmailTemplate where name = :name3].id;  
        Id templateId3 = [select id, name from EmailTemplate where name = :name4].id;  
        Id templateId4 = [select id, name from EmailTemplate where name = :name5].id;  
        Map<Id,Id> consumerList = new Map<Id,Id>();
        Set<Id> PersonAccountSet = new Set<Id>();
        String Str ;
    
//      if(UserInfo.getUserId() != '00540000002UfRh' && UserInfo.getUserId() !=null && UserInfo.getUserId() != '00540000002UfRhAAK'){     //Check if that is a SF2SF Connection User Id = 00540000002UfRh
        for(Opportunity opp1: Opp){  
            Opportunity oldOppp = OppOldMap.get(opp1.ID); 
            String Str1 = oldOppp.Status__c;
           //  if(opp1.Status__c == '6.6 Pending Pharmacy PO' && str1.left(3) <= '5.1'){
             if(opp1.Status__c != oldOppp.Status__c){
               PersonAccountSet.add(opp1.AccountId);   
             }
        }
        if(PersonAccountSet.size()>0){    
           Map<Id,Account> PersonAccountList = new Map<Id,Account>([Select Id,Name,PersonContactId,PersonEmail,PersonHasOptedOutOfEmail 
                                                                   from Account WHERE (IsPersonAccount != FALSE and PersonEmail !=null and PersonHasOptedOutOfEmail != true and Id IN: PersonAccountSet)]);
           for(Contact a: [SELECT Id,AccountId,Email FROM Contact WHERE AccountId IN : PersonAccountSet]){
              consumerList.put(a.AccountID,a.Id);   
           } 
        // Use Organization Wide Address 
           for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]){   
              if(owa.Address.contains('customerserviceinquiries')) { 
              OWDAddress = owa.id;   
              } 
           }  

           if(PersonAccountList.size() > 0 ){
                   for(Opportunity opp2: Opp) {        
                       Opportunity oldOpp = OppOldMap.get(opp2.ID);   
                       if(PersonAccountList.get(opp2.AccountId).PersonEmail != null){ 
                       customerEmailID = PersonAccountList.get(opp2.AccountId).PersonEmail;
                          if(AutoEmailHelper.firstRun){            
                              if(customerEmailID != null && Oldopp.status__c !=null && opp2.status__C !=null){
                                 String Strg = oldOpp.Status__c;
                                 if(opp2.Status__c == '6.6 Pending Pharmacy PO' && oldOpp.Status__c == '1.3 Pharmacy Check'){
                                   taskSubject = 'Pharm ping email sent – Intro to Dist.';
                                   AutoEmailHelper.sendTemplatedEmail(OWDAddress,consumerList.get(opp2.AccountId),opp2.ID,templateId); //send Email
                                   AutoEmailHelper.createTaskonOpportunity(taskSubject,taskComments,opp2.ID,opp2.OwnerId); //CreateTask 
                                 }else if((opp2.Status__c == '4.2 AS-Needs docs' && Strg.left(3) <= '4.2')|| (Opp2.Status__c == '4.3 Sales-Need Docs' && oldOpp.Status__c != '4.2 AS-Needs docs' && Strg.left(3) <= '4.3')){
                                   taskSubject = '4.2 AS Needs docs OR 4.3 – Needs docs email sent';
                                   AutoEmailHelper.sendTemplatedEmail(OWDAddress,consumerList.get(opp2.AccountId),opp2.ID,templateId1); //send Email
                                   AutoEmailHelper.createTaskonOpportunity(taskSubject,taskComments,opp2.ID,opp2.OwnerId); //CreateTask  
                                 }else if(opp2.Status__c == '5.1 Auth Submitted to Payor - MCS' && Strg.left(3) <= '5.1'){        
                                   taskSubject = '5.1 Auth Submitted email sent';
                                   AutoEmailHelper.sendTemplatedEmail(OWDAddress,consumerList.get(opp2.AccountId),opp2.ID,templateId2); //send Email
                                   AutoEmailHelper.createTaskonOpportunity(taskSubject,taskComments,opp2.ID,opp2.OwnerId); //CreateTask
                                 
                                 }else if(opp2.Status__c == '5.3A Authorized' && oldOpp.Status__c != '5.3B Denied' && Strg.left(3) <= '5.3'){ 
                                   taskSubject = '5.3A Authorized email sent';
                                   AutoEmailHelper.sendTemplatedEmail(OWDAddress,consumerList.get(opp2.AccountId),opp2.ID,templateId3); //send Email
                                   AutoEmailHelper.createTaskonOpportunity(taskSubject,taskComments,opp2.ID,opp2.OwnerId); //CreateTask  
                                    
                                 }else if(opp2.Status__c == '6.2 Insurance Quote Pending' && Strg.left(3) <= '6.2'){ 
                                   taskSubject = '6.2 Insurance Quote Pending email sent';
                                   AutoEmailHelper.sendTemplatedEmail(OWDAddress,consumerList.get(opp2.AccountId),opp2.ID,templateId4); //send Email
                                   AutoEmailHelper.createTaskonOpportunity(taskSubject,taskComments,opp2.ID,opp2.OwnerId); //CreateTask  
                                
                                }else{
                                // taskSubject = 'NO Pharm ping email sent – Intro to Dist.';
                                // taskComments = 'Missing email in Account';        
                                // AutoEmailHelper.createTaskonOpportunity(taskSubject,taskComments,opp2.ID,opp2.OwnerId); //Call createTask
                                 }
                                 }
                          } }
                   }      
                   AutoEmailHelper.firstRun = false;
        }
    }
}
}