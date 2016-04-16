@isTest

public class AccountTestClasses {

    Static testmethod void Testing_Account_Update_Opportunity_Trigger(){
    //1. Create a person Account    
   		
   		Id personRecordTypeID=[select Id from RecordType where (DeveloperName='Consumers') and (SobjectType='Account')].Id;
	    Id medFacilityRTypeID=[select Id from RecordType where (DeveloperName='Medical_Facility') and (SobjectType='Account')].Id;
	    Id prescriberRTypeID=[select Id from RecordType where (DeveloperName='Prescriber') and (SobjectType='Account')].Id;
	    Id payorRTypeId=[select Id from RecordType where (DeveloperName='Payor') and (SobjectType='Account')].Id;
	    Account pa = new Account(RecordTypeId = personRecordTypeID, PersonEmail = 'venkat.dexcom@gmail.com', LastName = 'AutoEMailTest', Party_ID__c = '99991', Territory_Code__c = 'BOSMA1');
	    insert pa;
	    
	    Account payor = TestDataBuilder.getAccountList(1, payorRTypeId)[0];//new Account(RecordTypeId = payorRTypeId, Party_ID__c = '99992', Territory_Code__c = 'BOSMA2');
	    insert payor;
	    
	    Account medicalFacility = TestDataBuilder.getAccountList(1, medFacilityRTypeID)[0];//new Account(RecordTypeId = medFacilityRTypeID, Name = 'Medical' Party_ID__c = '99992', Territory_Code__c = 'BOSMA2');
	    insert medicalFacility;
	    
	    Account prescriber = new Account(RecordTypeId = prescriberRTypeID, PersonEmail = 'prescriber.dexcom@gmail.com', LastName = 'AutoEMailTest', Party_ID__c = '99992', Territory_Code__c = 'BOSMA2');
	    insert prescriber;
	   	
	    Opportunity Opp = new Opportunity(Name='testy', StageName='testy', CloseDate = Date.Today(), accountid=pa.id);
	    insert Opp;
   		
	    pa.PersonMobilePhone = '8885551212';
	    pa.payor__c = payor.Id;
	    pa.prescribers__c = prescriber.Id;
	    pa.Medical_Facility__c = medicalFacility.Id;
	    
	    test.startTest();
	    	update pa;
		test.stopTest();
		
		Opportunity o = [SELECT Id, Payor__c, Prescribers__c, Medical_Facility__c FROM Opportunity WHERE Id = :Opp.Id];
		System.assertEquals(pa.payor__c, o.Payor__c);
		System.assertEquals(pa.prescribers__c, o.Prescribers__c);
		System.assertEquals(pa.Medical_Facility__c, o.Medical_Facility__c);
	    
	    
	}
	Static testmethod void Testing_Account_Update_Opportunity_Trigger_Bulk(){
		Integer recLimit = 20;
		Id personRecordTypeID=[select Id from RecordType where (DeveloperName='Consumers') and (SobjectType='Account')].Id;
	    Id medFacilityRTypeID=[select Id from RecordType where (DeveloperName='Medical_Facility') and (SobjectType='Account')].Id;
	    Id prescriberRTypeID=[select Id from RecordType where (DeveloperName='Prescriber') and (SobjectType='Account')].Id;
		Id payorRTypeId=[select Id from RecordType where (DeveloperName='Payor') and (SobjectType='Account')].Id;
		
		List<Account> accList = new list<Account>();
		list<Account> payorList = new list <Account>();
		list<Account> prescribersList = new list <Account>();
		list<Account> medicalFacilityList = new list <Account>();
		list <Opportunity> oppList = new list<Opportunity>();
		list <Opportunity> oppList2 = new list<Opportunity>();
		set <id> accountIds = new set<Id>();
		
		for (Integer i = 0 ; i < recLimit; i++){
			Account acc = TestDataBuilder.testAccount();
			acc.FirstName = acc.FirstName + i;
			acc.RecordTypeId = personRecordTypeID;
			acc.Territory_Code__c = 'BOSMA1';
			accList.add(acc);
		}
		insert accList;
		

		payorList = TestDataBuilder.getAccountList(recLimit, payorRTypeId);
		insert payorList;
		
		for (Integer i = 0 ; i < recLimit; i++){
			Account acc = TestDataBuilder.testAccount();
			acc.RecordTypeId = prescriberRTypeID;
			prescribersList.add(acc);
		}
		
		insert prescribersList;
		
		medicalFacilityList = TestDataBuilder.getAccountList(recLimit, medFacilityRTypeID);

		insert medicalFacilityList;
		
		for (Integer i = 0 ; i < recLimit; i++){
			list <Opportunity> tempList = TestDataBuilder.getOpportunityList(1, accList[i].Id, null);
			oppList.addAll(tempList);
		}
		insert oppList;
		
		for (Integer i = 0 ; i < recLimit; i++){
			list <Opportunity> tempList = TestDataBuilder.getOpportunityList(1, accList[i].Id, null);
			oppList2.addAll(tempList);
		}
		insert oppList2;
		
		for (Integer i = 0 ; i < recLimit; i++){
			accList[i].payor__c = payorList[i].Id;
			accList[i].prescribers__c = prescribersList[i].Id;
			accList[i].Medical_Facility__c = medicalFacilityList[i].Id;
			accountIds.add(accList[i].Id);
		}
		
		test.startTest();
			update accList;
		test.stopTest();
		
		for (Account acc: [SELECT Id, Payor__c, Prescribers__c, Medical_Facility__c, (SELECT Id, Payor__c, Prescribers__c, Medical_Facility__c FROM Opportunities) FROM Account WHERE Id In:accountIds]){
			for (Opportunity opp: acc.opportunities){
				System.assertEquals(acc.Payor__c, opp.Payor__c);
				System.assertEquals(acc.Prescribers__c, opp.Prescribers__c);
				System.assertEquals(acc.Medical_Facility__c, opp.Medical_Facility__c);
			}
		}
	
		
	}

    
}