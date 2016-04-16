/**********************************************
 * @author      : Kingsley Tumaneng
 * @date        : SEPT 9 2015
 * @description : Test Data for test classes
**********************************************/
public class TestDataBuilder {
    /**********************************************************
     **Description: Account Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.11.2015
    **********************************************************/
    public  static Account testAccount(){
        Account testAccount = new Account();
        testAccount.FirstName = 'Testfirstname';
        testAccount.LastName = 'Testlastname';
        testAccount.PersonEmail = 'Test@gmail.com';
        testAccount.Phone = '123456789';
        return testAccount;
    }
    /**********************************************************
     **Description: Lead Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.11.2015
    **********************************************************/
    public static Lead testLead(){
        Lead testLead = new Lead();
        testLead.FirstName = 'TestfirstName';
        testLead.LastName = 'TestlastName';
        testLead.Patient_Diabetes_Type__c = 'Type 1';
        testLead.Email = 'Test@gmail.com';
        testLead.Phone = '123456789';
        testLead.State = 'Test State';
        testLead.City = 'Test City';
        testLead.Street = 'Test Street';
        testLead.PostalCode = '1234';
        testLead.Doctor_City__c = 'Test Doc City';
        testLead.Doctor_Name__c = 'Test Doc Name';
        testLead.Doctor_State__c = 'Test Doc State';
        testLead.Doctor_Zip__c = 'Test Doc Zip';
        testLead.Insurance_Group_Number__c = '1';
        testLead.Insurance_Member_ID__c = '123456789';
        testLead.Insurance_Provider__c = 'Test Insurance Provider';
        testLead.Insurance_Type__c = 'Private Insurance';
        testLead.Relationship_to_PH__c = 'Self';
        testLead.Policy_Holder_DOB__c = System.today();
        testLead.Policy_Holder_First_Name__c = 'Test Policy Holder Fname';
        testLead.Policy_Holder_Gender__c = 'Male';
        testLead.Policy_Holder_Last_Name__c = 'Test Policy Holder Lname';
        return testLead;
    }
    /**********************************************************
     **Description: Lead Scoring Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.11.2015
    **********************************************************/
    public static Lead_Scoring__c testLeadScoringVal(){
        Lead_Scoring__c ls = new Lead_Scoring__c();
        ls.Name = 'a0e19000000EwIs';
        ls.Active_Evaluation_High__c = 55.0;
        ls.Active_Evaluation_Low__c = 45.0;
        ls.Applicable_High__c = 15.0;
        ls.Applicable_Low__c = 0.0;
        ls.Applicable_Mid__c = 10.0;
        ls.Contact_Info_High__c = 20.0;
        ls.Contact_Info_Low__c = 0.0;
        ls.Contact_Info_Mid__c = 10.0;
        ls.Insurance_Info_High__c = 15.0;
        ls.Insurance_Info_Low__c = 0.0;
        ls.Insurance_Info_Mid__c = 5.0;
        ls.Interest_High__c = 15.0;
        ls.Interest_Low__c = 0.0;
        ls.Interest_Mid__c = 10.0;
        ls.Not_Qualified_High__c = 25.0;
        ls.Not_Qualified_Low__c = 0.0;
        ls.Potential_Opportunity_High__c = 40.0;
        ls.Potential_Opportunity_Low__c = 30.0;
        ls.Prescriber_Info_High__c = 15.0;
        ls.Prescriber_Info_Low__c = 0.0;
        ls.Prescriber_Info_Mid__c = 5.0;
        ls.Qualified_Opportunity_High__c = 80.0;
        ls.Qualified_Opportunity_Low__c = 60.0;
        return ls;
    }
    /**********************************************************
     **Description: Contact Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.11.2015
    **********************************************************/
    public static Contact testContact(){
        Contact testContact = new Contact();
        testContact.FirstName = 'Test FirstName';
        testContact.LastName = 'Test LastName';
        testContact.Email = 'Test@gmail.com';
        return testContact;
    }
    /**********************************************************
     **Description: Url Expiry Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.30.2015
    **********************************************************/
    public static URL_Expiry__c testURLExpiryVal(){
        URL_Expiry__c urlE = new URL_Expiry__c();
        urlE.AlgorithmName__c = 'HMacSHA1';
        urlE.baseURL__c = 'https://site.test.com/webform.html';
        urlE.Expiry_Date__c = 7;
        urlE.secretKey__c = 'abcdefghijklmnopqrstuvwxyz';
        return urlE;
    }
    /**********************************************************
     **Description: Campaign Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    public static Campaign testCampaign(Id ownerId){
        Campaign c = new Campaign();
        c.OwnerId = ownerId;
        c.Name = 'Test Campaign';
        c.Type = 'Other';
        return c;
    }
    /**********************************************************
     **Description: User Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    static Id PROFILE_ID = [select Id From Profile Where Name = 'System Administrator'].Id;
        
        
    public static User testUser(){ 
        User usr = new User();
        usr.emailencodingkey = 'UTF-8';
        usr.languagelocalekey = 'en_US';
        usr.localesidkey = 'en_US';
        usr.profileid = PROFILE_ID;
        usr.timezonesidkey = 'America/Denver';
        usr.FirstName = 'FName';
        usr.alias = 'TUser';
        usr.email = 'TestUser' + '@hesser.com';
        usr.lastname = 'TUser';
        usr.username = 'TestUser' + '@hesser.com';
        usr.IsActive = true;
        usr.UserPermissionsMarketingUser = true;
        //usr.ContactId = conId;
        //usr.UserType = 'PowerCustomerSuccess';
        return usr;
    }
    /**********************************************************
     **Description: Default Campaign Test Data
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    public static Default_Campaign__c testDefaultCampaign(Id CampId){
        Default_Campaign__c dc = new Default_Campaign__c();
        dc.Default_Dex_Campaign__c = campId;
        return dc;
    }
    
    /************************Kingsley Tumaneng****************************/
    public static List<Account> getAccountList(Integer recLimit, Id recId){
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < recLimit; i++){
            Account acc = new Account();
                acc.Name = 'Test Account Name' + i;
                acc.RecordTypeId = recId;
            accList.add(acc);
        }
        return accList;
    }
    
    public static List<Account> getAccountListConsumer(Integer recLimit, Id recId){
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < recLimit; i++){
            Account acc = new Account();
                acc.FirstName = 'Test first';
                acc.LastName = 'Test Account Name' + i;
                acc.RecordTypeId = recId;
                acc.Territory_Code__c = '1234';
            accList.add(acc);
        }
        return accList;
    }
    
    public static List<Opportunity> getOpportunityList(Integer recLimit, Id acc, Id payor){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i = 0; i < recLimit; i++){
            Opportunity opp = new Opportunity();
                opp.Name = 'Test Opportunity Name' + i;
                opp.AccountId = acc;
                opp.StageName = 'New Opportunity';
                opp.CloseDate = date.today();
                opp.Type = 'NEW SYSTEM';
                opp.Payor__c = payor;
                opp.Expedited_Shipping__c = true;
                opp.Shipping_Method__c = 'ship to';
            oppList.add(opp);
        }
        return oppList;
    }
    
    public static List<Insurance_Document__c> getInsuranceDocument(Integer recLimit, String docName){
        List<Insurance_Document__c> insuranceDocList = new List<Insurance_Document__c>();
        for(Integer i = 0; i < recLimit; i++){
            Insurance_Document__c insuranceDoc = new Insurance_Document__c();
                insuranceDoc.Name = docName;
            insuranceDocList.add(insuranceDoc);
        }
        return insuranceDocList;
    }
    
    public static List<Required_Document__c> getRequireDocuments(Integer recLimit, Id insuranceId, Id accId){
        List<Required_Document__c> requiredDocsList = new List<Required_Document__c>();
        for(Integer i = 0; i < recLimit; i++){
            Required_Document__c requiredDocs = new Required_Document__c();
                requiredDocs.Payor__c = accId;
                requiredDocs.Document__c = insuranceId;
            requiredDocsList.add(requiredDocs);
        }
        return requiredDocsList;
    }
    
    public static List<DocuClass_Documents__c> getDocuClassDocuments(Integer recLimit ,Id acc, String docuType, Boolean approved){
        List<DocuClass_Documents__c> docuClassList = new List<DocuClass_Documents__c>();
        for(Integer i = 0; i < recLimit; i++){
            DocuClass_Documents__c docuClass = new DocuClass_Documents__c();
                docuClass.Document_Type__c = docuType;
                docuClass.Approved__c = approved;
                docuClass.Account__c = acc;
            docuClassList.add(docuClass);
        }
        return docuClassList;
    }
    
    public static List<Address__c> getAddressList(Id accId, Boolean isPrimary, String addressType, Integer recLimit){
        List<Address__c> addressList = new List<Address__c>();
        for(Integer i = 0; i < recLimit; i++){
            Address__c addrs = new Address__c();
                addrs.Account__c = accId;
                addrs.City__c = 'Test City';
                addrs.County__c = 'Test County';
                addrs.State__c = 'Test State';
                addrs.Zip_Postal_Code__c = 'Test Postal';
                addrs.Street_Address_1__c = 'Test Address';
                addrs.Primary_Flag__c = isPrimary;
                addrs.Address_Type__c = addressType;
            addressList.add(addrs);
        }
        return addressList;
    }
    
    public static List<Benefits__c> getBenefits(Id consumerId, Id payorId, Integer recLimit, String hierarchy, Id recId){
        List<Benefits__c> bnfList = new List<Benefits__c>();
        for(Integer i = 0; i < recLimit; i++){
            Benefits__c bnf = new Benefits__c();
                bnf.Account__c = consumerId;
                bnf.Payor__c = payorId;
                bnf.Benefit_Hierarchy__c = hierarchy;
                bnf.RecordTypeId = recId;
                bnf.Start_Date__c = date.today();
                //bnf.End_Date__c = date.today().addDays(1);
            bnfList.add(bnf);
        }   
        return bnfList;
    }
    
    public static OpportunityLineItem getOpportunityLineItem(String generation, Integer recLimit, Id oppId){
        Product2 prod = new Product2();
            prod.Name = 'Test Product' + recLimit;
            prod.IsActive = true;
            prod.Generation__c = generation;
        insert prod;
        
        Id pb = Test.getStandardPricebookID();
            
        PricebookEntry pbe = new PricebookEntry();
            pbe.UseStandardPrice = false;
            pbe.Pricebook2Id=pb;
            pbe.Product2Id=prod.id;
            pbe.IsActive=true;
            pbe.UnitPrice=100.0;
        insert pbe;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.PricebookEntryId = pbe.Id;
            oppLineItem.Quantity = 1;
            oppLineItem.UnitPrice = 1;
            oppLineItem.OpportunityId = oppId;
            oppLineItem.Description = 'test decription';
        return oppLineItem;
    }
    
    public static OpportunityLineItem getOpportunityLineItemCashPrice(String generation, Integer recLimit, Id oppId, Id pb, Decimal price){
        Product2 prod = new Product2();
            prod.Name = 'Test Product' + recLimit;
            prod.IsActive = true;
            prod.Generation__c = generation;
        insert prod;
        
        Id pbId = Test.getStandardPricebookID();
            
        PricebookEntry pbe = new PricebookEntry();
            pbe.UseStandardPrice = false;
            pbe.Pricebook2Id=pbId;
            pbe.Product2Id=prod.id;
            pbe.IsActive=true;
            pbe.UnitPrice=price;
        insert pbe;
        
        PricebookEntry pben = new PricebookEntry();
            pben.UseStandardPrice = false;
            pben.Pricebook2Id=pb;
            pben.Product2Id=prod.id;
            pben.IsActive=true;
            pben.UnitPrice=price;
        insert pben;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.PricebookEntryId = pben.Id;
            oppLineItem.Quantity = 1;
            oppLineItem.UnitPrice = price;
            oppLineItem.OpportunityId = oppId;
            oppLineItem.Description = 'test decription';
        return oppLineItem;
    }
    /************************Kingsley Tumaneng****************************/
    
    public static list <Product2> getProductList(integer recLimit, String ProductCode){
    	list <Product2> prodList =  new list <Product2>();
    	for(Integer i = 0 ; i < recLimit ; i++){
    		Product2 prod = new Product2(
    			Name = ProductCode,
    			ProductCode = ProductCode
    		);
    		prodList.add(prod);
    	}
    	return prodList;
    }        
        
    public static User getUser(String profile, String uname){ 
    	Id pId = [select Id From Profile Where Name =: profile].Id;
    	
        User usr = new User();
        usr.emailencodingkey = 'UTF-8';
        usr.languagelocalekey = 'en_US';
        usr.localesidkey = 'en_US';
        usr.profileid = pid;
        usr.timezonesidkey = 'America/Denver';
        usr.FirstName = uname;
        usr.alias = uname.substring(0,5);
        usr.email = uname + '@hesser.com';
        usr.lastname = uname;
        usr.username = uname + '@hesser.com';
        usr.IsActive = true;
        usr.UserPermissionsMarketingUser = true;
        //usr.ContactId = conId;
        //usr.UserType = 'PowerCustomerSuccess';
        return usr;
    }
    
    public static Territory_Alignment__c getTerritory(String code, list <User> userList){
    	Territory_Alignment__c ta = new Territory_Alignment__c(
    
	    	Name 				= code,
	    	Territory_Code__c 	= code,
	    	SA__c 				= userList[0].Id,
	    	PCS__c 				= userList[1].Id,	          
			Admin__c			= userList[2].Id,	                  
			MCS__c 				= userList[3].Id,	         
			DBM__c 				= userList[4].Id,	         
			RSD__c 				= userList[5].Id,		          
			Territory_Rep__c 	= userList[6].Id
    	);
    	return ta;
    }
    
    
    public static DocuClass_Documents__c getDocuClass(Id accId, String docType){
    	DocuClass_Documents__c d = new DocuClass_Documents__c(
    		Approved__c = false,
    		Document_Type__c = docType,
    		Object_Type__c =  'docuclass',
    		Account__c = accId
    	);
    	
    	return d;
    }
    	
    
    
}