public class DseAobHelper {
            
    /**
    * Finds Opportunity Information by opportunityId 
    */       
	public static Opportunity getOpportunity(string oopId) {
    	 List<Opportunity> opportunities = [Select o.ID_Lookup__c, o.Territory_Name__c, o.Patient_Last_Name__c, o.Patient_First_Name__c, 
    	 	o.Patient_Email__c From Opportunity o where o.Id = :oopId and o.Status__c='1.2 Online Opportunity' and o.IsClosed=false 
    	 	and o.StageName='1. New Opportunity'];

         if ( opportunities.size() != 0 ) { 
         	return opportunities.get(0); 
         }         
		 return null;
    }
    
	/**
    * Finds the user information assigned to a territory by territoryId 
    */
	public static User getUserByTerritoryId(string territoryId) {
    	 List<User> users = [select u.Email from User u where u.Id in (Select t.SA__c from Territory_Alignment__c t where t.Name=:territoryId)];

         if ( users.size() != 0 ) { 
         	return users.get(0); 
         }         
		 return null;
    }
    
    /**
    * Creates the XML version for X-DocuSign-Authentication with SOBO.
    */
    public static String CreateDocuSignAuthentication(String sobo, String dsIntegratorKey) {
    	 dsfs__DocuSignAccountConfiguration__c docuSignAccountConfiguration = getDsAccountConfiguration();
    	 
         if ( docuSignAccountConfiguration != null ) { 
         	return 	'<DocuSignCredentials><Username>' + docuSignAccountConfiguration.dsfs__DSProSFUsername__c +
         			'</Username><Password>' + docuSignAccountConfiguration.dsfs__DSProSFPassword__c +
         			'</Password><SendOnBehalfOf>' + sobo + '</SendOnBehalfOf>' + 
         			'<IntegratorKey>'+dsIntegratorKey+'</IntegratorKey></DocuSignCredentials>';
         }         
		 return null;
    }
    
    public static dsfs__DocuSignAccountConfiguration__c getDsAccountConfiguration() {
    	 List<dsfs__DocuSignAccountConfiguration__c> docuSignAccountConfiguration = [Select d.dsfs__UseSendOnBehalfOf__c, d.dsfs__DocuSignBaseURL__c, d.dsfs__DSProSFUsername__c, d.dsfs__DSProSFPassword__c, d.dsfs__AccountId__c From dsfs__DocuSignAccountConfiguration__c d limit 1];

         if ( docuSignAccountConfiguration.size() != 0 ) { 
         	return docuSignAccountConfiguration.get(0);
         }         
		 return null;
    }
    
    public static Account getAccountByOpportunityId(String oppId) {
    	 List<Account> account = [Select a.PersonEmail, a.PersonHomePhone, a.Name, a.Id, a.BillingState, a.BillingPostalCode, a.BillingCity, a.BillingAddress From Account a 
    	 	where a.Id in (Select o.AccountId From Opportunity o where o.Id = :oppId) and a.RecordTypeId in (select r.Id from RecordType r  where r.Name='Consumers') ];
         if ( account.size() != 0 ) { 
         	return account.get(0);
         }         
		 return null;
    }
}