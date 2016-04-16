/***************************************************************
 * @author      : Kingsley Tumaneng
 * @date        : SEPT 28 2015
 * @description : Test class for DocuClassDocumentTriggerHandler
****************************************************************/
@isTest
private class DocuClassDocumentTriggerHandlerTest {

	@isTest static void test() {
	    test.startTest();
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;
            Insurance_Document__c  insuranceDocs = TestDataBuilder.getInsuranceDocument(1, 'Rx-Prescription')[0];
                insert insuranceDocs;
            Required_Document__c requiredDoc = TestDataBuilder.getRequireDocuments(1, insuranceDocs.Id, acc.Id)[0];
                insert requiredDoc;
            DocuClass_Documents__c docuClass = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Rx-Prescription', true)[0];
                insert docuClass;
            Opportunity opp2 = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp2;
            List<Opportunity> oppList = [SELECT Id, RequiredDocs__c, RequiredDocsCount__c, 
                                         CollectedDocs__c, CollectedDocsCount__c, 
                                         MissingDocs__c, MissingDocsCount__c, HasAllDocs__c
                                         FROM Opportunity WHERE Id =: opp2.Id LIMIT 1];
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
	
	@isTest static void testUpdate() {
	    test.startTest();
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;
            Insurance_Document__c  insuranceDocs = TestDataBuilder.getInsuranceDocument(1, 'Rx-Prescription')[0];
                insert insuranceDocs;
            Required_Document__c requiredDoc = TestDataBuilder.getRequireDocuments(1, insuranceDocs.Id, acc.Id)[0];
                insert requiredDoc;
            DocuClass_Documents__c docuClass = TestDataBuilder.getDocuClassDocuments(1, acc.Id, 'Rx-Prescription', false)[0];
                insert docuClass;
            Opportunity opp2 = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp2;
            List<Opportunity> oppList = [SELECT Id, RequiredDocs__c, RequiredDocsCount__c, 
                                         CollectedDocs__c, CollectedDocsCount__c, 
                                         MissingDocs__c, MissingDocsCount__c, HasAllDocs__c
                                         FROM Opportunity WHERE Id =: opp2.Id LIMIT 1];
            List<Required_Document__c> reqList = [SELECT Id, Document__r.Name FROM Required_Document__c WHERE Id =: requiredDoc.Id];
            List<DocuClass_Documents__c> docuList = [SELECT Id, Document_Type__c, Approved__c FROM DocuClass_Documents__c WHERE Id =: docuClass.Id];
            
            docuList[0].Approved__c = false;
            update docuList;
            system.assertEquals(oppList[0].RequiredDocs__c, reqList[0].Document__r.Name);
            system.assertEquals(oppList[0].RequiredDocsCount__c, 1);
            system.assertEquals(oppList[0].CollectedDocs__c, docuList[0].Document_Type__c);
            system.assertEquals(oppList[0].CollectedDocsCount__c, 1);
            system.assertEquals(oppList[0].MissingDocs__c, docuList[0].Document_Type__c);
            system.assertEquals(oppList[0].MissingDocsCount__c, 1);
            system.assertEquals(oppList[0].HasAllDocs__c, false);
        test.stopTest();
	}
	
	private static testMethod void preventMultipleApprovedDocuTypeTest(){
		Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        Account acc = TestDataBuilder.getAccountListConsumer(1, recId)[0];
        insert acc;
        list <DocuClass_Documents__c> docuClassList =  new list <DocuClass_Documents__c>();
        set <String> docuTypeSet = new set <String> {'CMN', 'Assignment of Benefits', 'Authorizations'};
        Integer ctr = 0;
        for (Integer i = 0 ; i< 3; i++){
        	for (String s : docuTypeSet){
        		DocuClass_Documents__c d = TestDataBuilder.getDocuClass(acc.Id, s);
        		if (ctr <= 0){
        			d.Approved__c = true;
        		}
        		docuClassList.add(d);
        	}
        	++ctr;
        }
        
        insert docuClassList;
        
        test.startTest();
        	set <String> docTypeSet =  new set <String>();
        	list <DocuClass_Documents__c> docClassList =  new list <DocuClass_Documents__c>();
        	for(DocuClass_Documents__c d : [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Account__c =: acc.Id AND Approved__c = false]){
        		if(!docTypeSet.contains(d.Document_Type__c)){
        			docTypeSet.add(d.Document_Type__c);
        			d.Approved__c = true;
        			docClassList.add(d);
        		}
        	}
        	String err = '';
        	try{
        		update docClassList;
        	}catch(DMLException ex){
        		err = ex.getMessage();
        	}
        	
        test.stopTest();
        
        system.assert(err.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
		
	}
	private static testMethod void preventMultipleApprovedDocuTypeTest2(){
		Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        Account acc = TestDataBuilder.getAccountListConsumer(1, recId)[0];
        insert acc;
        list <DocuClass_Documents__c> docuClassList =  new list <DocuClass_Documents__c>();
        set <String> docuTypeSet = new set <String> {'CMN', 'Assignment of Benefits', 'Authorizations'};
        Integer ctr = 0;
        for (Integer i = 0 ; i< 3; i++){
        	for (String s : docuTypeSet){
        		DocuClass_Documents__c d = TestDataBuilder.getDocuClass(acc.Id, s);
        		docuClassList.add(d);
        	}
        	++ctr;
        }
        
        insert docuClassList;
        
        test.startTest();
        	list <DocuClass_Documents__c> docClassList =  new list <DocuClass_Documents__c>();
        	for(DocuClass_Documents__c d : [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Account__c =: acc.Id AND Approved__c = false]){
    			d.Approved__c = true;
    			docClassList.add(d);
        	}
        	String err = '';
        	try{
        		update docClassList;
        	}catch(DMLException ex){
        		err = ex.getMessage();
        	}
        	
        test.stopTest();
        
        system.assert(err.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
		
	}
	
	private static testMethod void preventMultipleApprovedDocuTypeTest3(){
		Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        Account acc = TestDataBuilder.getAccountListConsumer(1, recId)[0];
        insert acc;
        list <DocuClass_Documents__c> docuClassList =  new list <DocuClass_Documents__c>();
        set <String> docuTypeSet = new set <String> {'CMN', 'Assignment of Benefits', 'Authorizations'};
        Integer ctr = 0;
        for (Integer i = 0 ; i< 3; i++){
        	for (String s : docuTypeSet){
        		DocuClass_Documents__c d = TestDataBuilder.getDocuClass(acc.Id, s);
        		docuClassList.add(d);
        	}
        	++ctr;
        }
        
        insert docuClassList;
        
        test.startTest();
        	set <String> docTypeSet =  new set <String>();
        	list <DocuClass_Documents__c> docClassList =  new list <DocuClass_Documents__c>();
        	for(DocuClass_Documents__c d : [SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Account__c =: acc.Id AND Approved__c = false]){
        		if(!docTypeSet.contains(d.Document_Type__c)){
        			docTypeSet.add(d.Document_Type__c);
        			d.Approved__c = true;
        			docClassList.add(d);
        		}
        	}
        	String err = '';
        	try{
        		update docClassList;
        	}catch(DMLException ex){
        		err = ex.getMessage();
        	}
        	
        test.stopTest();
        
        list <DocuClass_Documents__c> updatedDocuClass = ([SELECT Id, Document_Type__c FROM DocuClass_Documents__c WHERE Account__c =: acc.Id AND Approved__c = true]);
		system.assertEquals(3, updatedDocuClass.size());
	}
	
	
}