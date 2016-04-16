/*********************************************************
 * @author      : Kingsley Tumaneng
 * @date        : SEPT 9 2015
 * @description : Test class for OpportunityTriggerHandler
*********************************************************/
@isTest
private class OpportunityTriggerHandlerTest {
    private static Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
    
    //ADDED BY Noy De Goma@CSHERPAS on 01.07.2016
    //-- START
    @testSetup static void testData(){
    	User systAd = TestDataBuilder.testUser();
    	system.runAs(systAd){
    		Territory_Opportunity_Team_Role__c totc = new Territory_Opportunity_Team_Role__c(
    			SA__c 				= 'SA - Sales Administrator',
				PCS__c 				= 'PCS - Patient Care Specialist',          
				Admin__c 			= 'Administrative Assistant',                 
				MCS__c 				= 'MCS - Manaaged Care Specialist',	         
				DBM__c				= 'DBM - District Sales Manager',         
				RSD__c				= 'RSD - Regional Sales Director',        
				Territory_Rep__c	= 'Temporary TBM'
    		);
    		insert totc;
    		
	    	Account acc = TestDataBuilder.getAccountList(1, recId)[0];
	    	acc.Territory_Code__c = '1234';
	        insert acc;
	    	
	    	list <User> userList = new list <User>();
	    	for(Integer i = 0; i < 7; i++){
	    		User u = TestDataBuilder.getUser('System Administrator', 'User' + i + 'Test');
	    		userList.add(u);
	    	}
	    	insert userList;
	    	
	    	Territory_Alignment__c territory = TestDataBuilder.getTerritory('1234', userList);
	    	insert territory;
    	}
    }
    //-- END
    
	@isTest static void afterInsertTest() {
	    test.startTest();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Insurance_Document__c  insuranceDocs = TestDataBuilder.getInsuranceDocument(1, 'Rx-Prescription')[0];
                insert insuranceDocs;
            Insurance_Document__c  insuranceDocs2 = TestDataBuilder.getInsuranceDocument(1, 'Assignment of Benefits')[0];
                insert insuranceDocs2;
            Required_Document__c requiredDoc = TestDataBuilder.getRequireDocuments(1, insuranceDocs.Id, acc.Id)[0];
                insert requiredDoc;
            Required_Document__c requiredDoc2 = TestDataBuilder.getRequireDocuments(1, insuranceDocs2.Id, acc.Id)[0];
                insert requiredDoc2;
            DocuClass_Documents__c docuClass = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Rx-Prescription', true)[0];
                insert docuClass;
            DocuClass_Documents__c docuClass2 = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Authorizations', false)[0];
                insert docuClass2;
            DocuClass_Documents__c docuClass4 = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Authorizations', false)[0];
                insert docuClass4;
            DocuClass_Documents__c docuClass5 = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Authorizations', true)[0];
                insert docuClass5;
            DocuClass_Documents__c docuClass3 = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Assignment of Benefits', false)[0];
                insert docuClass3;
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;    
            
            List<Opportunity> oppList = [SELECT Id, RequiredDocs__c, RequiredDocsCount__c, 
                                         CollectedDocs__c, CollectedDocsCount__c, 
                                         MissingDocs__c, MissingDocsCount__c, HasAllDocs__c
                                         FROM Opportunity WHERE Id =: opp.Id LIMIT 1];
            List<Required_Document__c> reqList = [SELECT Id, Document__r.Name FROM Required_Document__c WHERE Id =: requiredDoc.Id];
            List<Required_Document__c> reqList2 = [SELECT Id, Document__r.Name FROM Required_Document__c WHERE Id =: requiredDoc2.Id];
            List<DocuClass_Documents__c> docuList = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass.Id];
            List<DocuClass_Documents__c> docuList2 = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass2.Id];
            List<DocuClass_Documents__c> docuList3 = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass3.Id];
            List<DocuClass_Documents__c> docuList4 = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass4.Id];
            List<DocuClass_Documents__c> docuList5 = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass5.Id];
            
            system.assertEquals(oppList[0].RequiredDocs__c, reqList[0].Document__r.Name + '; ' + reqList2[0].Document__r.Name);
            system.assertEquals(oppList[0].RequiredDocsCount__c, 2);
            system.assertEquals(oppList[0].CollectedDocs__c, docuList[0].Document_Type__c + '; ' + docuList4[0].Document_Type__c + '; ' + docuList5[0].Document_Type__c + '; ' + docuList2[0].Document_Type__c + '; ' + docuList3[0].Document_Type__c);
            system.assertEquals(oppList[0].CollectedDocsCount__c, 5);
            system.assertEquals(oppList[0].MissingDocs__c, docuClass3.Document_Type__c);
            system.assertEquals(oppList[0].MissingDocsCount__c, 1);
            system.assertEquals(oppList[0].HasAllDocs__c, false);
        test.stopTest();
	}
	
	@isTest static void afterInsertListTest() {
	    test.startTest();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            List<Opportunity> opp = TestDataBuilder.getOpportunityList(2, acc.Id, acc.Id);
                insert opp;
            
            system.assert(true, opp.size() > 1);
        test.stopTest();
	}
	
	@isTest static void afterInsertPayorIsNullTest() {
	    test.startTest();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Insurance_Document__c  insuranceDocs = TestDataBuilder.getInsuranceDocument(1, 'Rx-Prescription')[0];
                insert insuranceDocs;
            Required_Document__c requiredDoc = TestDataBuilder.getRequireDocuments(1, insuranceDocs.Id, acc.Id)[0];
                insert requiredDoc;    
            DocuClass_Documents__c docuClass = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Rx-Prescription', true)[0];
                insert docuClass;
            Opportunity opp = TestDataBuilder.getOpportunityList(2, acc.Id, null)[0];
                insert opp;    
                
            List<Opportunity> oppList = [SELECT Id, RequiredDocs__c, RequiredDocsCount__c, 
                                         CollectedDocs__c, CollectedDocsCount__c, 
                                         MissingDocs__c, MissingDocsCount__c, HasAllDocs__c
                                         FROM Opportunity WHERE Id =: opp.Id LIMIT 1];
            List<DocuClass_Documents__c> docuList = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass.Id];
            
            system.assertEquals(oppList[0].RequiredDocs__c, null);
            system.assertEquals(oppList[0].RequiredDocsCount__c, 0);
            system.assertEquals(oppList[0].CollectedDocs__c, docuList[0].Document_Type__c);
            system.assertEquals(oppList[0].CollectedDocsCount__c, 1);
            system.assertEquals(oppList[0].MissingDocs__c, null);
            system.assertEquals(oppList[0].MissingDocsCount__c, 0);
            system.assertEquals(oppList[0].HasAllDocs__c, false);
        test.stopTest();
	}
	
	@isTest static void BeforeUpdateTest() {
	    test.startTest();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;
            UtilityClass.runTrigger = true;
            
            Account acc2 = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc2;
            Insurance_Document__c  insuranceDocs = TestDataBuilder.getInsuranceDocument(1, 'Rx-Prescription')[0];
                insert insuranceDocs;
            Required_Document__c requiredDoc = TestDataBuilder.getRequireDocuments(1, insuranceDocs.Id, acc2.Id)[0];
                insert requiredDoc;
            DocuClass_Documents__c docuClass = TestDataBuilder.getDocuClassDocuments(1, acc2.Id, 'Rx-Prescription', true)[0];
                insert docuClass;
            opp.Payor__c = acc2.Id;
            opp.AccountId = acc2.Id;
                update opp;
            
            List<Opportunity> oppList = [SELECT Id, RequiredDocs__c, RequiredDocsCount__c, 
                                         CollectedDocs__c, CollectedDocsCount__c, 
                                         MissingDocs__c, MissingDocsCount__c, HasAllDocs__c
                                         FROM Opportunity WHERE Id =: opp.Id LIMIT 1];
            List<Required_Document__c> reqList = [SELECT Id, Document__r.Name FROM Required_Document__c WHERE Id =: requiredDoc.Id];
            List<DocuClass_Documents__c> docuList = [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Id =: docuClass.Id];
            
            system.assertEquals(oppList[0].RequiredDocs__c, reqList[0].Document__r.Name);
            system.assertEquals(oppList[0].RequiredDocsCount__c, 1);
            system.assertEquals(oppList[0].CollectedDocs__c, docuList[0].Document_Type__c);
            system.assertEquals(oppList[0].CollectedDocsCount__c, 1);
            system.assertEquals(oppList[0].MissingDocs__c, null);
            system.assertEquals(oppList[0].MissingDocsCount__c, 0);
            system.assertEquals(oppList[0].HasAllDocs__c, true);
        test.stopTest();
	}
	
	@isTest static void BeforeUpdateLstTest() {
	    test.startTest();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            List<Opportunity> opp = TestDataBuilder.getOpportunityList(2, acc.Id, acc.Id);
                insert opp;
            UtilityClass.runTrigger = true;
            Account acc2 = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc2;
            opp[0].Payor__c = acc2.Id;
            opp[1].Payor__c = acc2.Id;
                update opp;
                
            system.assert(true, opp.size() > 1);
        test.stopTest();
	}
	
	// ADDED BY Noy De Goma@CSHERPAS on 01.07.2016
    //-- START
	private static testMethod void createOpportunityTeamTestScenario1(){
		Territory_Opportunity_Team_Role__c totcCS = Territory_Opportunity_Team_Role__c.getOrgDefaults();
		Territory_Alignment__c ta = [SELECT SA__c, PCS__c, Admin__c, MCS__c, DBM__c, RSD__c, Territory_Rep__c, Territory_Code__c
    										FROM Territory_Alignment__c WHERE Territory_Code__c = '1234'];
		Account acc = [SELECT Id FROM Account WHERE Name  = 'Test Account Name0' limit 1];
		Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
		test.startTest();
        	insert opp;
    	test.stopTest();
    	
    	list <OpportunityTeamMember> oppTeamList = [SELECT Id, UserId, TeamMemberRole FROM OpportunityTeamMember];
    	System.assertEquals(7, oppTeamList.size());
    	
    	
    	for (OpportunityTeamMember mem : oppTeamList){
    		if(mem.TeamMemberRole == totcCS.SA__c){
    			System.assertEquals(ta.SA__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.PCS__c){
    			System.assertEquals(ta.PCS__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.Admin__c){
    			System.assertEquals(ta.Admin__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.MCS__c){
    			System.assertEquals(ta.MCS__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.DBM__c){
    			System.assertEquals(ta.DBM__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.RSD__c){
    			System.assertEquals(ta.RSD__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.Territory_Rep__c){
    			System.assertEquals(ta.Territory_Rep__c, mem.UserId);
    		}
    	}
	}
	
	private static testMethod void createOpportunityTeamTestScenario2(){
		Territory_Opportunity_Team_Role__c totcCS = Territory_Opportunity_Team_Role__c.getOrgDefaults();
		Territory_Alignment__c ta = [SELECT SA__c, PCS__c, Admin__c, MCS__c, DBM__c, RSD__c, Territory_Rep__c, Territory_Code__c
    										FROM Territory_Alignment__c WHERE Territory_Code__c = '1234'];
		list <Opportunity> oppList = new list <Opportunity>();
		Account acc = [SELECT Id FROM Account WHERE Name  = 'Test Account Name0' limit 1];
		oppList = TestDataBuilder.getOpportunityList(2, acc.Id, acc.Id);
		test.startTest();
        	insert oppList;
    	test.stopTest();

    	
    	for (Opportunity opp : [SELECT Id, (SELECT Id, TeamMemberRole, UserId FROM OpportunityTeamMembers) FROM Opportunity]){
    		System.assertEquals(7, opp.OpportunityTeamMembers.size());
    		for (OpportunityTeamMember mem : opp.OpportunityTeamMembers){
	    		if(mem.TeamMemberRole == totcCS.SA__c){
	    			System.assertEquals(ta.SA__c, mem.UserId);
	    		}
	    		if(mem.TeamMemberRole == totcCS.PCS__c){
	    			System.assertEquals(ta.PCS__c, mem.UserId);
	    		}
	    		if(mem.TeamMemberRole == totcCS.Admin__c){
	    			System.assertEquals(ta.Admin__c, mem.UserId);
	    		}
	    		if(mem.TeamMemberRole == totcCS.MCS__c){
	    			System.assertEquals(ta.MCS__c, mem.UserId);
	    		}
	    		if(mem.TeamMemberRole == totcCS.DBM__c){
	    			System.assertEquals(ta.DBM__c, mem.UserId);
	    		}
	    		if(mem.TeamMemberRole == totcCS.RSD__c){
	    			System.assertEquals(ta.RSD__c, mem.UserId);
	    		}
	    		if(mem.TeamMemberRole == totcCS.Territory_Rep__c){
	    			System.assertEquals(ta.Territory_Rep__c, mem.UserId);
	    		}
    		}
    	}
	}
	
	private static testMethod void createOpportunityTeamTestScenario3(){
		Territory_Opportunity_Team_Role__c totcCS = Territory_Opportunity_Team_Role__c.getOrgDefaults();
		Territory_Alignment__c ta = [SELECT SA__c, PCS__c, Admin__c, MCS__c, DBM__c, RSD__c, Territory_Rep__c, Territory_Code__c
    										FROM Territory_Alignment__c WHERE Territory_Code__c = '1234'];
		list <Opportunity> oppList = new list <Opportunity>();
		Account acc = [SELECT Id FROM Account WHERE Name  = 'Test Account Name0' limit 1];
		User u =  [SELECT id FROM User WHERE username = 'TestUser@hesser.com' limit 1];
		User u2 =  [SELECT id, IsActive FROM User WHERE username = 'User0Test@hesser.com'];
		system.runAs(u){

			u2.IsActive = false;
			
			update u2;
		}
		
		oppList = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id);
		test.startTest();
        	insert oppList;
    	test.stopTest();
    	list <OpportunityTeamMember> oppTeamList = [SELECT Id, TeamMemberRole, UserId FROM OpportunityTeamMember];
    	System.assertEquals(6, oppTeamList.size());
    	for (OpportunityTeamMember mem : oppTeamList){
    		if(mem.TeamMemberRole == totcCS.SA__c){
    			System.assertEquals(ta.SA__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.PCS__c){
    			System.assertEquals(ta.PCS__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.Admin__c){
    			System.assertEquals(ta.Admin__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.MCS__c){
    			System.assertEquals(ta.MCS__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.DBM__c){
    			System.assertEquals(ta.DBM__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.RSD__c){
    			System.assertEquals(ta.RSD__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.Territory_Rep__c){
    			System.assertEquals(ta.Territory_Rep__c, mem.UserId);
    		}
    	}
		
		
	}
	
	private static testMethod void createOpportunityTeamTestScenario4(){
		Territory_Opportunity_Team_Role__c totcCS = Territory_Opportunity_Team_Role__c.getOrgDefaults();
		Territory_Alignment__c ta = [SELECT SA__c, PCS__c, Admin__c, MCS__c, DBM__c, RSD__c, Territory_Rep__c, Territory_Code__c
    										FROM Territory_Alignment__c WHERE Territory_Code__c = '1234'];
    	ta.SA__c = null;
    	ta.MCS__c = null;
    	
    	update ta;
    	
		list <Opportunity> oppList = new list <Opportunity>();
		Account acc = [SELECT Id FROM Account WHERE Name  = 'Test Account Name0' limit 1];
		User u =  [SELECT id FROM User WHERE username = 'TestUser@hesser.com' limit 1];

		oppList = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id);
		test.startTest();
        	insert oppList;
    	test.stopTest();
    	list <OpportunityTeamMember> oppTeamList = [SELECT Id, TeamMemberRole, UserId FROM OpportunityTeamMember];
    	System.assertEquals(5, oppTeamList.size());
    	for (OpportunityTeamMember mem : oppTeamList){
    		if(mem.TeamMemberRole == totcCS.SA__c){
    			System.assertEquals(ta.SA__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.PCS__c){
    			System.assertEquals(ta.PCS__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.Admin__c){
    			System.assertEquals(ta.Admin__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.MCS__c){
    			System.assertEquals(ta.MCS__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.DBM__c){
    			System.assertEquals(ta.DBM__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.RSD__c){
    			System.assertEquals(ta.RSD__c, mem.UserId);
    		}
    		if(mem.TeamMemberRole == totcCS.Territory_Rep__c){
    			System.assertEquals(ta.Territory_Rep__c, mem.UserId);
    		}
    	}
		
		
	}
	
	//-- END
}