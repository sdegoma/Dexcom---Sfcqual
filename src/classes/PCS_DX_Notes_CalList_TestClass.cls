/***************************************************************************

@Author: Venkat Kollimarla

This is to test the trigger PCS_DX_Notes_CalList Trigger's code coverage.
@Method : TestPositiveCase

*****************************************************************************/

@isTest
public class PCS_DX_Notes_CalList_TestClass
    {

            Static testmethod void TestPositiveCase()
                {

                        //Create an account of Person Account
                        System.debug('Entered Psitive Test Case');
                        Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
                        Account acc1 = new Account(RecordTypeId = personRecordTypeID, PersonEmail = 'buyeda@dexcom.com', LastName = 'AutoEMailTest', Party_ID__c = '99991');
    
                        try{
    
                            Insert acc1; 
                                  System.debug('Account Created');
    
      
                            //Create DX_Note with Ref to the acc above created
                            DX_Notes__c note = new DX_Notes__c();
                            note.Call_List_DX_Note__c = true;
                            note.Call_Type__c = 'test Call';
                            note.Comments__c = 'test';
                            note.CONSUMER__c = acc1.Id;
                            note.Oracle_Notes_Id__c = '1259';
                            note.PC_Reasons__c = 'testing';
                            note.Interaction_Status__c = 'Completed - no follow up'; 
                                                   
    
                            insert note;
    
    
                            }//END OF Try{}
    
                        catch (System.DmlException e) 
                           {
                                        for (Integer i = 0; i < e.getNumDml(); i++) 
                                        {
                                                    // Process exception here
                                                                System.debug(e.getDmlMessage(i)); 
                                        }
                            }//END OF Catch{}
                    }//
                    
        }