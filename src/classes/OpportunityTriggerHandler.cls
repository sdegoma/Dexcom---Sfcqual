/**************************************************************************
 * @author          : Kingsley Tumaneng
 * @date            : SEPT 3, 2015
 * @description     : Class that will populate fields form Oppotunity
**************************************************************************/
public class OpportunityTriggerHandler {
    
    /********************************************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 3 2015
     * param        : List of Opportunity to be insert
     * return       : void
     * description  : Update Required Documents, Required Document Count,
     *                Collected Documents, Collected Documents Count,
     *                Missing Documents, Missing Documents Count fiels
     *                on Opportunity based on Payor
     * revision(s)  :
    ********************************************************************/
    public static void afterInsert(List<Opportunity> oppList){
      list <Opportunity> oppWithTerritoryList = new list <Opportunity>();
        if(oppList.size() == 1){
            Set<Id> oppId = new Set<Id>();
            for(Opportunity opp : oppList){
                oppId.add(opp.Id);
                
                // ADDED BY Noy De Goma@CSHERPAS on 01.07.2016
              if(!String.isEmpty(opp.Territory_Name__c)){
                oppWithTerritoryList.add(opp);
              } 
            }
           
            for(Opportunity opp : [SELECT Id, Name, Payor__c, AccountId FROM Opportunity WHERE Id IN : oppId]){
                processOpportunity(opp.Payor__c, opp.Id, opp, opp.AccountId);
            }
            
        }else{
            Set<Id> oppId = new Set<Id>();
            for(Opportunity opp : oppList){
                oppId.add(opp.Id);
                // ADDED BY Noy De Goma@CSHERPAS on 01.07.2016
              if(!String.isEmpty(opp.Territory_Name__c)){
                oppWithTerritoryList.add(opp);
              }
            }
            if(!oppId.isEmpty()){
                Database.executeBatch(new ProcessMultipleOpportunity(oppId), 20);
                System.debug('***Batch');
            }
        }
        //ADDED BY Noy De Goma@CSHERPAS
        createOpportunityTeam(oppWithTerritoryList);
    }
    
    
    /**
     *@description  : this method is responsible for creating opportunity team members upon 
     *          creation depending on the Territory Name assigned to the Opportunity
     *@author    : Noy De Goma@CSHERPAS
     *@date     : 01.07.2016
     *@param     : opportunityList - list of opportunities with assigned Territory Name
     *@return    : N/A
    **/
    
    private static void createOpportunityTeam(list <Opportunity> opportunityList){
      list <String> territoryCodeList = new list <String>();
      List<OpportunityTeamMember> lstOppTeams = new List<OpportunityTeamMember>();
      map <String, Territory_Alignment__c> territoryMap = new map <String, Territory_Alignment__c>();
      Territory_Opportunity_Team_Role__c terrCS = Territory_Opportunity_Team_Role__c.getOrgDefaults();
      for (Opportunity o : opportunityList){
        territoryCodeList.add(o.Territory_Name__c);
      }
      
      for (Territory_Alignment__c ta : [SELECT SA__c, PCS__c, Admin__c, MCS__c, DBM__c, RSD__c, Territory_Rep__c, Territory_Code__c
                        FROM Territory_Alignment__c WHERE Territory_Code__c IN: territoryCodeList]){
      territoryMap.put(ta.Territory_Code__c, ta);
      }
      
      for (Opportunity o : opportunityList){
        if(territoryMap.get(o.Territory_Name__c) != null){
          if(territoryMap.get(o.Territory_Name__c).SA__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.SA__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).SA__c);
          lstOppTeams.add(otm);
          }
          if(territoryMap.get(o.Territory_Name__c).PCS__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.PCS__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).PCS__c);
          lstOppTeams.add(otm);
          }
          if(territoryMap.get(o.Territory_Name__c).Admin__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.Admin__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).Admin__c);
          lstOppTeams.add(otm);
          }
          if(territoryMap.get(o.Territory_Name__c).MCS__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.MCS__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).MCS__c);
          lstOppTeams.add(otm);
          }
          if(territoryMap.get(o.Territory_Name__c).DBM__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.DBM__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).DBM__c);
          lstOppTeams.add(otm);
          }
          if(territoryMap.get(o.Territory_Name__c).RSD__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.RSD__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).RSD__c);
          lstOppTeams.add(otm);
          }
          if(territoryMap.get(o.Territory_Name__c).Territory_Rep__c != null){
            OpportunityTeamMember otm = new OpportunityTeamMember(
               TeamMemberRole = terrCS.Territory_Rep__c, 
                   OpportunityId  = o.Id,
                   UserId         = territoryMap.get(o.Territory_Name__c).Territory_Rep__c);
          lstOppTeams.add(otm);
          }
        }
        
      }
      

      Database.SaveResult[] results = Database.insert(lstOppTeams,false);
      if (results != null){
          for (Database.SaveResult result : results) {
              if (!result.isSuccess()) {
                  Database.Error[] errs = result.getErrors();
                  for(Database.Error err : errs){
                      System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                  }
              }
          }
      }
    
    
      
      
    }
    
    /********************************************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 3 2015
     * param        : List of Opportunity to be update
     * return       : void
     * description  : Update Required Documents, Required Document Count,
     *                Collected Documents, Collected Documents Count,
     *                Missing Documents, Missing Documents Count fiels
     *                on Opportunity based on Payor
     * revision(s)  :
    ********************************************************************/
    public static void beforeUpdate(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){
        if(oppList.size() == 1){
            for(Opportunity opp : oppList){
                system.debug('***oldMap.get(opp.Id).Payor__c = ' + oldMap.get(opp.Id).Payor__c);
                if(opp.Payor__c != oldMap.get(opp.Id).Payor__c){
                    processOpportunity(opp.Payor__c, opp.Id, opp, opp.AccountId);
                }
            }
        }else{
            Set<Id> oppId = new Set<Id>();
            for(Opportunity opp : oppList){
                if(opp.Payor__c != oldMap.get(opp.Id).Payor__c){
                   oppId.add(opp.Id); 
                }
            }
            if(!oppId.isEmpty()){
                Database.executeBatch(new ProcessMultipleOpportunity(oppId), 20);
                System.debug('***Batch');
            }
            
        }
        
    }
    
    /********************************************************************
     * author       : Scottie OBryan
     * date         : JAN 12 2016
     * param        : List of Opportunity to be update
     * return       : void
     * description  : Set the oppty owner to be the account owner
                      except when user is Data Integrator
     * revision(s)  :
    ********************************************************************/
    public static void beforeInsert(List<Opportunity> oppList){
       
        Set<ID> acctIDs = New Set<ID>();
      Map<ID,ID> accToOwner = New Map<ID,ID>();
      
      if(UserInfo.getName() != 'Actian DataIntegrator'){
        
        for(Opportunity opp : oppList){
            acctIDs.add(opp.accountID);
        }
    
        for(Account a : [Select OwnerID From Account Where ID IN :acctIDs]){
            accToOwner.put(a.id,a.ownerID);
        }
    
        for(Opportunity opp : oppList){
            if(accToOwner.containsKey(opp.AccountID))
                opp.OwnerID = accToOwner.get(opp.AccountID);
        }
      }
    }
    
    /***********************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 14 2015
     * param        : payorId - Opportunity PayorId
     *              : opptyId - OpportunityId
     *              : opp - Opportunity
     *              : acctId - Opportunity AccountId
     * return(s)    : void
     * description  : method to process Opportunity
     * revision(s)  :
    ***********************************************/
    public static void processOpportunity(Id payorId, Id opptyId, Opportunity opp, Id acctId){
        List<String> docuCls = new List<String>();
        List<String> required = new List<String>();
        List<String> missingDocument = new List<String>();
        
        required = getRequiredDocuList(payorId);
        docuCls = getDocuClassList(acctId);
        missingDocument = getMissingDocuList(payorId, acctId);
        
        List<Opportunity> toInsert = new List<Opportunity>();
        if(payorId != null){
            String replacedRequired = removeString(required);
            String replacedDocu = removeString(docuCls);
            String replacedMissing = removeString(missingDocument);
            
            system.debug('***replacedRequired = ' + replacedRequired);
            system.debug('***replacedDocu = ' + replacedDocu);
            system.debug('***replacedMissing = ' + replacedMissing);
            
            opp.RequiredDocs__c = replacedRequired;
            opp.RequiredDocsCount__c = required.size();
            opp.CollectedDocs__c = replacedDocu;
            opp.CollectedDocsCount__c = docuCls.size();
            opp.MissingDocs__c = replacedMissing;
            opp.MissingDocsCount__c = missingDocument.size();
            
            if(missingDocument.size() == 0){
                if(required.size() == 0){
                    opp.HasAllDocs__c = false;
                }else{
                    opp.HasAllDocs__c = true;
                }
            }else {
                opp.HasAllDocs__c = false;
            }
            toInsert.add(opp);
        }
        else{
            String replacedDocu = removeString(docuCls);
            
            opp.RequiredDocs__c = '';
            opp.RequiredDocsCount__c = 0;
            opp.CollectedDocs__c = replacedDocu;
            opp.CollectedDocsCount__c = docuCls.size();
            opp.MissingDocs__c = '';
            opp.MissingDocsCount__c = 0;
            opp.HasAllDocs__c = false;
            toInsert.add(opp);
        }
        
        try{
            if(!toInsert.isEmpty()){
                update toInsert;
            }
        }catch(Exception ex){
            system.debug('***ERROR INSERT/UPDATE');
        }
    }
    
    /***********************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 8 2015
     * param        : List of String
     * return(s)    : replaced(String) - modified
     *                String 
     * description  : modifying list(strnig) to 
     *                remove removed "(" , ")" and 
     *                replaced "," to ";"
     * revision(s)  : 
    ***********************************************/
    public static String removeString(List<String> str){
        String removeFirst = String.valueOf(str).remove('(');
        String removeLast = String.valueOf(removeFirst).remove(')');
        String replaced = String.valueOf(removeLast).replace(',',';');
        
        return replaced;
    }
    
    /***********************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 10 2015
     * param        : Payor Id in Opportunity
     * return(s)    : required(String) - List of
     *                String for Required Documents
     * description  : Loop for Required Documents 
     *                for the specific Payor
     * revision(s)  : 
    ***********************************************/
    public static List<String> getRequiredDocuList(Id payorId){
        List<String> required = new List<String>();
        
        for(Required_Document__c reqDoc : [SELECT Id, 
                                           Document__r.Name, 
                                           Payor__c 
                                           FROM Required_Document__c 
                                           WHERE Payor__c =: payorId]){
                                               
            required.add(reqDoc.Document__r.Name);
            system.debug('***reqDoc.Document__r.Name = ' + reqDoc.Document__r.Name);
        }
        system.debug('***required = ' + required);
        required.sort();
        return required;
    }
    
    /***********************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 10 2015
     * param        : Opportunity Id
     * return(s)    : docuCls(String) - List of
     *                String for DocuCLass Documents
     * description  : Loop for DocuCLass Documents 
     *                for the specific Opportunity
     * revision(s)  : 
    ***********************************************/
    public static List<String> getDocuClassList(Id accId){
        List<String> docuCls = new List<String>();
        
        for(DocuClass_Documents__c docuClass : [SELECT Id, 
                                                Document_Type__c, 
                                                Account__c, 
                                                Approved__c
                                                FROM DocuClass_Documents__c 
                                                WHERE Account__c =: accid]){
                                         
            docuCls.add(docuClass.Document_Type__c);
        }
        docuCls.sort();
        return docuCls;
    }
    
    /***********************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 10 2015
     * param        : Opportunity Id
     *                Payor Id
     * return(s)    : missingDocument(String) - List
     *                of String for Missing Documents
     * description  : Remove item from the list if
     *                the DocuClass name are in the
     *                Required Documents
     * revision(s)  : 
    ***********************************************/
    public static List<String> getMissingDocuList(Id payorId, Id accid){
        List<String> missingDocument = new List<String>();
        List<String> docuCls = new List<String>();
        List<String> required = new List<String>();
        List<String> mergeString = new List<String>();
        List<String> notYetApproved = new List<String>();
        List<String> aprrovedDocs = new List<String>();
        
        missingDocument = getRequiredDocuList(payorId);
        docuCls = getDocuClassList(accid);
        required = getRequiredDocuList(payorId);
        
        //remove collected docs on the required documents
        for(String docuClass : docuCls){
            for(Integer x=missingDocument.size() - 1; x >=0; x--){
                String s = missingDocument[x];
                if(s.contains(docuClass)){
                    missingDocument.remove(x);
                }
            }
        }
        
        
        for(DocuClass_Documents__c docuClass : [SELECT Id, 
                                                Document_Type__c, 
                                                Account__c, 
                                                Approved__c 
                                                FROM DocuClass_Documents__c 
                                                WHERE Account__c =: accid AND Approved__c = false]){
            notYetApproved.add(docuClass.Document_Type__c);      
        }
        
        List<String> tempMissing = getDistinctDocuTypeName(notYetApproved);
        system.debug('***notYetApproved = ' + notYetApproved);
        system.debug('***tempMissing = ' + tempMissing);
        
        //add DocuType that are not yet approved
        for(String str : tempMissing){
            for(Integer x= 0; x < required.size(); x++){
                String s = required[x];
                if(s.contains(str)){
                    mergeString.add(str);
                }
            }
        }
        
        for(String str : mergeString){
            missingDocument.add(str);
        }
        
        for(DocuClass_Documents__c docuClass : [SELECT Id, 
                                                Document_Type__c, 
                                                Account__c, 
                                                Approved__c 
                                                FROM DocuClass_Documents__c 
                                                WHERE Account__c =: accid AND Approved__c = true]){
            aprrovedDocs.add(docuClass.Document_Type__c);      
        }//approved
        
        //remove Docutype that are approved
        for(String docuClass : aprrovedDocs){
            for(Integer x= missingDocument.size() - 1; x >=0; x--){
                String s = missingDocument[x];
                if(s.contains(docuClass)){
                    missingDocument.remove(x);
                }
            }
        }
        
        missingDocument.sort();
        return missingDocument;
    }
    
    public static List<String> getDistinctDocuTypeName(List<String> duplicates){
        List<String> distinctDocuTypeName = new List<String>();
        for(String docuTypeName: duplicates){
            Boolean found = false;
            for(Integer i=0; i< distinctDocuTypeName.size(); i++){
                if(docuTypeName.equalsIgnoreCase(distinctDocuTypeName[i])){ //Check if current docuTypeName has been added yet
                    found=true;
                    break;
                }
            }
            if(!found){
                distinctDocuTypeName.add(docuTypeName);
            }
        }
        return distinctDocuTypeName;
    }
}