/***********************************************************
PCSTestClasses Test Class Object
R00
   @Author : Charles Nothdurft
   Date : 12/18/2014
R01
   @Author : Charles Nothdurft
   Date 4/2/2015
R02
   @Author : Charles Nothdurft
   Date 6/4/2015
   This test verifies the following PCS triggers operate as designed. 
   PCS_DX_Notes_CalListTrigger
   PCS_DX_Notes_InteractionStatus
   PCS_DX_Notes_CalList

Revision(s):
02  6/4/2015. Chuck Nothdurft. Added test cases for no value in Integration_Status__c. 
************************************************************/
@isTest
public class PCSTestClasses{
Static testmethod void TestingPCS_DX_Notes_CalListTrigger()
  {
//1-1. Create a person Account    
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
    Account pa = new Account(RecordTypeId = personRecordTypeID, PersonEmail = 'buyeda@dexcom.com', LastName = 'AutoEMailTest', Call_list__c=true, Party_ID__c = '99991');
    insert pa;
//1-2. Create a DX Note with ref to the above created Person Account
    DX_Notes__c note1 = new DX_Notes__c ();
    note1.Interaction_Status__c = 'Completed - no follow up';
    note1.Call_List_DX_Note__c=true;
    note1.CONSUMER__c = pa.id;
    try{  insert note1; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//1-3. Create a DX Note with ref to the above created Person Account
    DX_Notes__c note2 = new DX_Notes__c ();
    note2.Interaction_Status__c = 'Completed - no follow up';
    note2.Call_List_DX_Note__c = true;
    note2.CONSUMER__c = pa.id;
    try{  insert note2; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
  }
Static testmethod void TestingNewOrderCheckingTrigger()
/* positive case only does not test failure case
   Creates a Person Account record
   Creates a related Order Header record
   Creates a related Order Item Detail record
*/
  {
//2-1. Populate a person Account    
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
    Account pa = new Account(RecordTypeId = personRecordTypeID, PersonEmail = 'buyeda@dexcom.com', LastName = 'AutoEMailTest', Party_ID__c = '99991');
    try{  insert pa; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//2-2. Populate an ORDER Header record related to the person Account (Positive Case)
    Order_Header__c OH1 = new Order_Header__c();
    OH1.Account__c = pa.id;
    OH1.Order_Type__c = 'Standard Sales Order';
    try{  insert OH1; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//2-3. Populate an ORDER Header record related to the person Account (Negative Case)
    Order_Header__c OH2 = new Order_Header__c();
    OH2.Account__c = pa.id;
    OH2.Order_Type__c = 'Technical Refresh';
    try{  insert OH2; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//2-4. Populate an Order item Detail record related to the Order Header (Positive case)
    Order_Item_Detail__c OID1 = new Order_Item_Detail__c ();
    OID1.Order_Header__c = OH1.Id;
    OID1.Shipping_Date__c = System.today();
    OID1.Item_Number__c = 'STK-GL-BLU';
    try{  insert OID1; }
    catch (System.DmlException e) 
    {for (Integer i = 0; i < e.getNumDml(); i++) 
       {// Process exception here 
         System.debug(e.getDmlMessage(i)); 
       }
    }
//2-5. Create Order item Detail with Ref to ORDER HEADER (Negative Case - Item Number)
    Order_Item_Detail__c OID2 = new Order_Item_Detail__c ();
    OID2.Order_Header__c = OH1.Id;
    OID2.Shipping_Date__c = System.today();
    OID2.Item_Number__c = 'STK-GL-110';
    try{  insert OID2; }
    catch (System.DmlException e) 
    {for (Integer i = 0; i < e.getNumDml(); i++) 
      {// Process exception here 
        System.debug(e.getDmlMessage(i)); 
      }
    }  
//2-6. Create Order item Detail with Ref to ORDER HEADER (Negative Case - Sale Type)
    Order_Item_Detail__c OID3 = new Order_Item_Detail__c ();
    OID3.Order_Header__c = OH2.Id;
    OID3.Shipping_Date__c = System.today();
    OID3.Item_Number__c = 'STK-GL-BLU';
    try{  insert OID3; }
    catch (System.DmlException e) 
    {for (Integer i = 0; i < e.getNumDml(); i++) 
      {// Process exception here 
        System.debug(e.getDmlMessage(i)); 
      }
    }  
  }

Static testmethod void TestingPCS_DX_Notes_InteractionStatusTrigger()
  {
//3-1. Create a valid person Account
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
    Account pa = new Account(RecordTypeId = personRecordTypeID, PersonEmail = 'buyeda@dexcom.com', LastName = 'AutoEMailTest', Party_ID__c = '99991');
    insert pa;
//3-2. Insert a valid PCS Note with ref to the above created Person Account
    DX_Notes__c note = new DX_Notes__c ();
    note.Call_List_DX_Note__c = true;
    note.Interaction_Status__c = 'ABCDEF';
    note.CONSUMER__c = pa.id;
//3-2.1 Exception handling
    try{  insert note; }  
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//3-4. Update the created DX Note Interaction Status
    note.Interaction_Status__c = 'QWERTY';
    try { update note; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }

//02 START
//3-5. Insert a valid DX Note (No Interaction Status) with ref to the above created Person Account
    DX_Notes__c note1 = new DX_Notes__c ();
    note1.Interaction_Status__c = '';
    note1.CONSUMER__c = pa.id;
//3-5.1 Exception handling
    try{  insert note1; }  
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//3-6. Update the created DX Note1 Interaction Status
    note1.Comments__c = '';
    try { update note1; }
    catch (System.DmlException e) 
    {   for (Integer i = 0; i < e.getNumDml(); i++) 
            {   // Process exception here 
                System.debug(e.getDmlMessage(i)); 
            }
    }
//02 END
  }
}//Closing Class{}