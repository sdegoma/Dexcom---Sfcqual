@istest
public class PCSCallListTest {
/********************************************************************************
@author Abhishek Parghi
@date 10/08/2015
@description: Test class for PCS Call List.
*******************************************************************************/
    Static testmethod void TestReturnCallList(){ 
        Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
        Account acc1 = new Account();
        acc1.RecordTypeId = personRecordTypeID;
        acc1.FirstName = 'Testfirstname';
        acc1.LastName = 'Testlastname';
        acc1.PersonEmail = 'TestAP@gmail.com';
        acc1.Phone = '1234567890';
        acc1.BillingState = 'Test State';
        acc1.BillingCity = 'Test City';
        acc1.BillingStreet = 'Test Street';
        acc1.BillingPostalCode = '1234';
        acc1.BillingCountry = 'United States';
        insert acc1;
        
        DX_Notes__c note1 = new DX_Notes__c();
               note1.Return_Call_List__c = true;
               note1.Call_Type__c = 'Outbound';
               note1.Comments__c = 'test';
               note1.CONSUMER__c = acc1.Id;
               note1.Oracle_Notes_Id__c = '1259';
               note1.PC_Reasons__c = '508 Educate: setting Out of Range alert';
               note1.Interaction_Status__c = 'Follow up in 7'; 
          insert note1;
        DX_Notes__c note2 = new DX_Notes__c();
               note2.Return_Call_List__c = true;
               note2.Call_Type__c = 'Outbound';
               note2.Comments__c = 'test';
               note2.CONSUMER__c = acc1.Id;
               note2.Oracle_Notes_Id__c = '1259';
               note2.PC_Reasons__c = '508 Educate: setting Out of Range alert';
               note2.Interaction_Status__c = 'Completed - no follow up'; 
          insert note2;
        DX_Notes__c note3 = new DX_Notes__c();
               note3.Return_Call_List__c = true;
               note3.Call_Type__c = 'Outbound';
               note3.Comments__c = 'test';
               note3.CONSUMER__c = acc1.Id;
               note3.Oracle_Notes_Id__c = '1259';
               note3.PC_Reasons__c = '508 Educate: setting Out of Range alert';
               note3.Interaction_Status__c = 'Patient will call when additional support is needed.'; 
          insert note3;
        
        Order_Header__c OH = new Order_Header__c();
              OH.Account__c  = acc1.Id;
          insert OH; 
        
        Order_Item_Detail__c OI = new Order_Item_Detail__c();
              OI.Order_Header__c = OH.ID;
              OI.Shipping_Date__c = date.today();
           //   Oi.ACC_ID__c = acc1.ID; 
          //       OI.Shipping_Date__c = datetime.newInstance(2016, 1, 1, 12, 30, 0); 
        insert OI; 
    //    System.assertEquals(Oi.ACC_ID__c, ACC1.id);       
        
}  
}