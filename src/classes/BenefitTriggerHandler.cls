/*************************************************
 * @author      : Kingsley Tumaneng
 * @date        : OCT 6, 2015
 * @description : Class to update Account.Payor__c
*************************************************/
public class BenefitTriggerHandler {
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : OCT 6, 2015
     * param        : Benefit list 
     * return(s)    : void
     * description  : method for checking on 
     *                before insert if the Payor__c is 
     *                changing then it will update the
     *                payor on the Account
     * revision(s)  : 
    *************************************************/
    public static void beforeInsert(List<Benefits__c> benefitList){
        List<Account> toBeUpdated = new List<Account>();
        Map<Id, Benefits__c> mapAccIdBenefits = new Map<Id, Benefits__c>();
        Map<Id, Benefits__c> mapBenefitsTobeInserted = new Map<Id, Benefits__c>();
        
        for(Benefits__c bnf : benefitList){
            mapBenefitsTobeInserted.put(bnf.Account__c, bnf);
            if(bnf.Payor__c != null && bnf.Benefit_Hierarchy__c == 'Primary'){
                mapAccIdBenefits.put(bnf.Account__c, bnf);
            }
        }
        
        if(!mapAccIdBenefits.isEmpty()){
            List<Account> accList = [SELECT Id, Payor__c
                                     FROM Account WHERE Id IN: mapAccIdBenefits.keySet()];
            for(Account acc : accList){
                acc.Payor__c = mapAccIdBenefits.get(acc.Id).Payor__c;
                toBeUpdated.add(acc);
            } 
        }
        
        checkHierarchy(mapBenefitsTobeInserted);
        // ADDED by Noy De Goma@CSHERPAS on 02.04.2016
        //-- START
        if (UserInfo.getName() != 'Actian DataIntegrator'){
            setPageStatus(benefitList);
        }
        //-- END
        
        if(!toBeUpdated.isEmpty()){
            update toBeUpdated;
        }
    }
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : OCT 6, 2015
     * param        : Benefit oldmap
     *                Benefit list 
     * return(s)    : void
     * description  : method for checking on 
     *                before update if the 
     *                Hierarchy is "Primary" and the 
     *                Payor__c is changing then
     *                it will update the Payor__c on
     *                the Account
    *************************************************/
    public static void afterUpdate(List<Benefits__c> benefitList, Map<Id, Benefits__c> oldMap){
        List<Account> toBeUpdated = new List<Account>();
        Map<Id, Benefits__c> mapAccIdBenefits = new Map<Id, Benefits__c>();
        
        for(Benefits__c bnf : benefitList){
            if(bnf.Payor__c != oldMap.get(bnf.Id).Payor__c && bnf.Benefit_Hierarchy__c == 'Primary'){
                mapAccIdBenefits.put(bnf.Account__c, bnf);
            }
        }
        
        if(!mapAccIdBenefits.isEmpty()){
            List<Account> accList = [SELECT Id, Payor__c
                                     FROM Account WHERE Id IN: mapAccIdBenefits.keySet()];
            for(Account acc : accList){
                acc.Payor__c = mapAccIdBenefits.get(acc.Id).Payor__c;
                toBeUpdated.add(acc);
            }
        }
        
        if(!toBeUpdated.isEmpty()){
            update toBeUpdated;
        }
    }
    
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : DEC 1 2015
     * param        : Benefit oldmap
     *                Benefit list 
     * return(s)    : void
     * description  : method for checking on 
     *                before update if the 
     *                Create_New_Benefit_Record__c is 
     *                checked or the Payor__c is changing
     *                it will null all of the RIDs
    *************************************************/
    public static void beforeUpdate(List<Benefits__c> benefitList, Map<Id, Benefits__c> oldMap){
        Map<Id, Benefits__c> mapBenefitsTobeInserted = new Map<Id, Benefits__c>();
        for(Benefits__c bnf : benefitList){
            if(bnf.Benefit_Hierarchy__c != oldMap.get(bnf.Id).Benefit_Hierarchy__c){
               mapBenefitsTobeInserted.put(bnf.Account__c, bnf); 
            }
            
            if(bnf.Payor__c != oldMap.get(bnf.Id).Payor__c || bnf.Create_New_Benefit_Record__c == true){
                //bnf.Create_New_Benefit_Record__c = false; //moved reset of this to workflow rule
                bnf.RID_IC__c = null;
                bnf.RID_P1__c = null;
                bnf.RID_P2__c = null;
                bnf.RID_PA__c = null;
                bnf.Start_Date__c = System.today();
                bnf.End_Date__c = null;
            }
        }
        
        if(!mapBenefitsTobeInserted.isEmpty()){
            checkHierarchy(mapBenefitsTobeInserted);
        }
        // ADDED by Noy De Goma@CSHERPAS on 02.04.2016
        //-- START
        if (UserInfo.getName() != 'Actian DataIntegrator'){
            setPageStatus(benefitList);
        }
        //-- END
    }
   
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : DEC 1 2015
     * param        : Benefit map
     * return(s)    : void
     * description  : Add checking if Hierarchy of the
     *                record that being inserted is equal
     *                Hierarchy of the existing record
     *                of the Account
    *************************************************/
    public static void checkHierarchy(Map<Id, Benefits__c> mapBenefitsTobeInserted){
        for(Benefits__c bnf : [SELECT Id, 
                              Account__c, 
                              RecordTypeId,
                              Party_ID__c,
                              Benefit_Hierarchy__c,
                              RID_IC__c,
                              RID_P1__c,
                              RID_P2__c,
                              RID_PA__c,
                              Create_New_Benefit_Record__c
                              FROM Benefits__c WHERE Account__c IN: mapBenefitsTobeInserted.keySet()]){
            
            system.debug('****bnf.Benefit_Hierarchy__c = ' + bnf.Benefit_Hierarchy__c);
            system.debug('****mapBenefitsTobeInserted.get(bnf.Account__c).Benefit_Hierarchy__c = ' + mapBenefitsTobeInserted.get(bnf.Account__c).Benefit_Hierarchy__c);
            
            if(bnf.Benefit_Hierarchy__c == mapBenefitsTobeInserted.get(bnf.Account__c).Benefit_Hierarchy__c){
                system.debug('****ERROR');
                mapBenefitsTobeInserted.get(bnf.Account__c).addError('There is already a benefit record of that Benefit Hierarchy type ' +
                  'BNFId: ' + bnf.Id + ' BNFAccount: ' + bnf.Account__c + ' BNFPartyID: ' + bnf.Party_ID__c + ' BNFHier: ' + bnf.Benefit_Hierarchy__c +
                  ' BIaccount: ' + mapBenefitsTobeInserted.get(bnf.Account__c).Account__c +
                  ' BIhier: ' + mapBenefitsTobeInserted.get(bnf.Account__c).Benefit_Hierarchy__c);
            }
        }
    }
    
    /**
     *@description  : this method will set the the fields IntStatuses to "i" if the actual user who created the benefit record
                      is the "Actian Dataintegrator"
     *@author       : Noy De Goma@CSHERPAS
     *@date         : 02.04.2016
     *@param        : benefitsList - list of benefits that are newly created
     *@return       : N/A
    **/
    
    private static void setPageStatus(list<Benefits__c> benefitsList){
        for(Benefits__c b : benefitsList){
            b.IntStatus_P1__c = 'I';
            b.IntStatus_P2__c = 'I';
            b.IntStatus_IC__c = 'I';
            b.IntStatus_PA__c = 'I';
        }
    }
    
 Public static void DX_DSC_Insur_Info(list<Benefits__c> benefitsList){   
    /**********************************************************************
        * Business Description:                                               
        *           The insurance card information need to be pulled on to 
        * the Account instead of Opportunity every time a Benefit record is inserted or  
        * updated and the relationship code would determine the values for the 
        * primary and secondary fields (Passing the info onto) accordingly. 
        *                                                                     
        * Author: Venkat Kollimerla                                                                   
        *                                                                    
        *                                                                     
        **********************************************************************/
        //Dear Developer, Whenever you make changes to this - Please mention what changes have been made with comments around your code
        /**************************************************************
        *   History Log
        *       Date : 10/17/2014
        *       Programmer : Venkat Kollimerla
        *       
        *       Change number: 001
        *       CR: 439
        *       Date: 2/18/2016
        *       Programmer: Brian Uyeda
        *       Change Description: Benefits object changed and the existing code was not properly 
        *       populating the fields, this change corrects that issue
        *
        **************************************************************/
    
    Set<ID> AccountIDs = new Set<ID>();
    List<Account> acctsToUpdate = new List<Account>();
    Map<ID,Benefits__c> BenMap = new Map<ID,Benefits__C>(); //AccountID --> BenefitsObject Mapping
    // BHU 001
    //Id BenRecordTypeID =[select Id from RecordType where (Name='Insurance Card') and (SobjectType='Benefits__c')].Id;
    Id BenRecordTypeID =[select Id from RecordType where (Name='Benefits') and (SobjectType='Benefits__c')].Id;
    // END 001
    //1. Get the accounts of benefits
    for(Benefits__c b: benefitsList){
        if(b.RecordTypeId == BenRecordTypeID){ 
            // BHU 001              
            // if((b.Relationship_Code__c == 'Primary') || (b.Relationship_Code__c == 'Secondary'))
            if((b.Benefit_Hierarchy__c == 'Primary') || (b.Benefit_Hierarchy__c == 'Secondary')){            // END 001
                AccountIDs.add(b.Account__c);
                BenMap.put(b.Account__c, b);
            }
        }
    }
    //2. get all Accounts associated with these identified Benefits
    if(AccountIDs.size()>0) {
            acctsToUpdate = [SELECT ID,Secondary_Claims_Mailing_Address__c,Secondary_Customer_Service_Phone__c,Secondary_Employer_Group__c,
                             Secondary_Member_ID__c,Secondary_Plan_Name__c,Secondary_Plan_Type__c,Secondary_Policy_Holder_DOB__c,
                             Secondary_Policy_Holder_Name__c,Secondary_Relationship_to_Patient__c,
            Primary_Claims_Mailing_Address__c,Primary_Customer_Service_Phone__c,Primary_Employer_Group__c,Primary_Member_ID__c,
            Primary_Plan_Name__c,Primary_Plan_Type__c,Primary_Policy_Holder_DOB__c,Primary_Policy_Holder_Name__c,
            Primary_Relationship_to_Patient__c FROM Account WHERE ID in : AccountIDs];
    //3. Update fields accordingly
    if(acctsToUpdate.size()>0){
      for(Account acc : acctsToUpdate){
        if(BenMap.containsKey(acc.Id)){
            // BHU 001
            //if(BenMap.get(acc.Id).Relationship_Code__c == 'Primary')   //If PRIMARY - populate respective fields
            if(BenMap.get(acc.Id).Benefit_Hierarchy__c == 'Primary'){
                acc.Primary_Member_ID__c = BenMap.get(acc.Id).MEMBER_ID__c;
                acc.Primary_Employer_Group__c = BenMap.get(acc.Id).Employer_Group__c;
                acc.Primary_Customer_Service_Phone__c = BenMap.get(acc.Id).Customer_Service_Phone__c;
                acc.Primary_Claims_Mailing_Address__c = BenMap.get(acc.Id).Claims_Mailing_Address__c;
                acc.Primary_Policy_Holder_Name__c     = BenMap.get(acc.Id).Policy_Holder_Name__c;
                acc.Primary_Policy_Holder_DOB__c      = BenMap.get(acc.Id).Policy_Holder_Date_of_Birth__c;
                acc.Primary_Relationship_to_Patient__c = BenMap.get(acc.Id).RELATIONSHIP_TO_PATIENT__c;
                acc.Primary_Plan_Name__c = BenMap.get(acc.Id).Plan_Name__c;
                acc.Primary_Plan_Type__c = BenMap.get(acc.Id).Plan_Type__c;                
            }
            // BHU 001
            //if(BenMap.get(acc.Id).Relationship_Code__c == 'Secondary')   //If SECONDARY - populate respective fields
            if(BenMap.get(acc.Id).Benefit_Hierarchy__c == 'Secondary')  {// END 001
                // BHU 001
                acc.Secondary_Insurance__c = BenMap.get(acc.Id).Payor__c;
                // END 001
                acc.Secondary_Member_ID__c = BenMap.get(acc.Id).MEMBER_ID__c;
                acc.Secondary_Employer_Group__c = BenMap.get(acc.Id).Employer_Group__c;
                acc.Secondary_Customer_Service_Phone__c = BenMap.get(acc.Id).Customer_Service_Phone__c;
                acc.Secondary_Claims_Mailing_Address__c = BenMap.get(acc.Id).Claims_Mailing_Address__c;
                acc.Secondary_Policy_Holder_Name__c     = BenMap.get(acc.Id).Policy_Holder_Name__c;
                acc.Secondary_Policy_Holder_DOB__c      = BenMap.get(acc.Id).Policy_Holder_Date_of_Birth__c;
                acc.Secondary_Relationship_to_Patient__c= BenMap.get(acc.Id).RELATIONSHIP_TO_PATIENT__c;
                acc.Secondary_Plan_Name__c = BenMap.get(acc.Id).Plan_Name__c;
                acc.Secondary_Plan_Type__c = BenMap.get(acc.Id).Plan_Type__c;                
            }
        }
    }
    update acctsToUpdate;
  }//acctsToUpdate IF - Ends Here
 }//AccounIDs - IF - Ends Here
}
}