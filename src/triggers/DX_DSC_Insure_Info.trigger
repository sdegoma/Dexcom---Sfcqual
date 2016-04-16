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

trigger DX_DSC_Insure_Info on Benefits__c (before insert,before update) {
    
    Set<ID> AccountIDs = new Set<ID>();
    List<Account> acctsToUpdate = new List<Account>();
    Map<ID,Benefits__c> BenMap = new Map<ID,Benefits__C>(); //AccountID --> BenefitsObject Mapping
    
    // BHU 001
    //Id BenRecordTypeID =[select Id from RecordType where (Name='Insurance Card') and (SobjectType='Benefits__c')].Id;
    Id BenRecordTypeID =[select Id from RecordType where (Name='Benefits') and (SobjectType='Benefits__c')].Id;
    // END 001
    
    //1. Get the accounts of benefits
    
    for(Benefits__c b: Trigger.new)
    {    
           
        if(b.RecordTypeId == BenRecordTypeID)
        { 
            // BHU 001              
            // if((b.Relationship_Code__c == 'Primary') || (b.Relationship_Code__c == 'Secondary'))
            if((b.Benefit_Hierarchy__c == 'Primary') || (b.Benefit_Hierarchy__c == 'Secondary'))
            // END 001
                        {
                            AccountIDs.add(b.Account__c);
                            BenMap.put(b.Account__c, b);
                        }
        }
        
    }
     
    //2. get all Accounts associated with these identified Benefits
    
    if(AccountIDs.size()>0)
    {
            acctsToUpdate = [SELECT ID,Secondary_Claims_Mailing_Address__c,Secondary_Customer_Service_Phone__c,Secondary_Employer_Group__c,
                             Secondary_Member_ID__c,Secondary_Plan_Name__c,Secondary_Plan_Type__c,Secondary_Policy_Holder_DOB__c,
                             Secondary_Policy_Holder_Name__c,Secondary_Relationship_to_Patient__c,
            Primary_Claims_Mailing_Address__c,Primary_Customer_Service_Phone__c,Primary_Employer_Group__c,Primary_Member_ID__c,
            Primary_Plan_Name__c,Primary_Plan_Type__c,Primary_Policy_Holder_DOB__c,Primary_Policy_Holder_Name__c,
            Primary_Relationship_to_Patient__c FROM Account WHERE ID in : AccountIDs];
      
    //3. Update fields accordingly
    
    if(acctsToUpdate.size()>0)
    {
        
    for(Account acc : acctsToUpdate)
    {
        if(BenMap.containsKey(acc.Id))
        {
            // BHU 001
            //if(BenMap.get(acc.Id).Relationship_Code__c == 'Primary')   //If PRIMARY - populate respective fields
            if(BenMap.get(acc.Id).Benefit_Hierarchy__c == 'Primary')   //If PRIMARY - populate respective fields
            // END 001
            {
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
            if(BenMap.get(acc.Id).Benefit_Hierarchy__c == 'Secondary')   //If SECONDARY - populate respective fields
            // END 001
            {
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