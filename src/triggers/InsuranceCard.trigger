trigger InsuranceCard on Benefits__c (before insert) {

 /*   Set<ID> AccountIDs = new Set<ID>();
    List<Account> acctsToUpdate = new List<Account>();
    Map<ID,Benefits__c> BenMap = new Map<ID,Benefits__C>(); //AccountID --> BenefitsObject Mapping
    
    Id BenRecordTypeID =[select Id from RecordType where (Name='Insurance Card') and (SobjectType='Benefits__c')].Id;
    
    //1. Get the accounts of benefits
    
    for(Benefits__c b: Trigger.new)
    {    
           
        if(b.RecordTypeId == BenRecordTypeID)
        {               
            if((b.Relationship_Code__c == 'Primary') || (b.Relationship_Code__c == 'Secondary'))
                        {
                            AccountIDs.add(b.Account__c);
                            BenMap.put(b.Account__c, b);
                        }
        }
        
    }*/
}