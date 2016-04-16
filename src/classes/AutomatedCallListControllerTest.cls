/********************************************************************************
@author Abhishek Parghi
@date 11/20/2015
@description: Test class for AutomatedCallListController 
*******************************************************************************/

@istest
public class AutomatedCallListControllerTest {

             public static testMethod void testSearchAccount() {
             List<Account> acc = new List<Account>();
             List<Dx_Notes__c > Dxx= new List<Dx_Notes__c >();  
          
             Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
             Account accc= new Account();
                     accc.RecordTypeId = personRecordTypeID;
                       accc.FirstName = 'APTestfirstname2';
                       accc.LastName = 'APTestlastname2';
                       accc.PersonEmail = 'APTestAP@gmail.com';
                       accc.Phone = 'Call: 1234567890012345678900';
                       accc.BillingState = 'APTest State';
                       accc.BillingCity = 'APTest City';
                       accc.BillingStreet = 'APTest Street';
                       accc.ShippingPostalCode =  '95112';
                       accc.BillingCountry = 'United States';
                       accc.Prescriber__c = null;
                     
                insert acc;
       
             for(Integer i=0; i < 41; i++)  {
                 Account acc8= new Account();
                       acc8.RecordTypeId = personRecordTypeID;
                       acc8.FirstName = 'APTestfirstname2'+ i;
                       acc8.LastName = 'APTestlastname2';
                       acc8.PersonEmail = 'APTestAP@gmail.com';
                       acc8.Phone = 'Call: 1234567890012345678900';
                       acc8.BillingState = 'APTest State';
                       acc8.BillingCity = 'APTest City';
                       acc8.BillingStreet = 'APTest Street';
                       acc8.ShippingPostalCode =  '95112';
                       acc8.BillingCountry = 'United States';
                       acc8.Prescriber__c = null;
                       acc.add(acc8);
                }
              
                insert acc;
            Account accct = acc[0];
 
             Dx_Notes__c Dx = new Dx_Notes__c ();
                      Dx.Call_Type__c = 'Outbound';
                      Dx.Comments__c = 'PC NOTE: Follow-up outreach completed';
                      Dx.CONSUMER__c = acc[0].id;
                      Dx.Oracle_Notes_Id__c = '1259';
                      Dx.PC_Reasons__c = '821 Patient Care Outreach, left vmail';
                      Dx.Interaction_Status__c = 'Follow up in 90'; 
               insert Dx;
           for(Integer i=0; i < 20; i++) {
                     Dx_Notes__c Dx1 = new Dx_Notes__c ();
                     Dx1.Return_Call_List__c= true;
                     Dx1.Call_Type__c = 'Outbound';
                     Dx1.Comments__c = 'PC NOTE: Outreach to customer. Information about product training, education and ongoing support resources provided.';
                     Dx1.CONSUMER__c = accct.id;
                     Dx1.Oracle_Notes_Id__c = '1259'+i;
                     Dx1.PC_Reasons__c = '840 Patient Care Outreach';
                     Dx1.Interaction_Status__c = 'Follow up in 30'; 
                     Dxx.add(dx1);
           }
        if(acc[0].id !=null){  
           insert Dxx;
        }  
        ApexPages.StandardsetController sc = new ApexPages.StandardsetController (acc);
        ApexPages.currentPage().getParameters().put('Id',acc[0].id);
         
        AutomatedCallListController instance = new AutomatedCallListController(sc);
        AutomatedCallListController.AutomatedCallListWrapper tt =  new AutomatedCallListController.AutomatedCallListWrapper(acc[0]);
        
        AutomatedCallListController  p=new AutomatedCallListController ();
    
        
        p.getcategories();
        p.Next();
        p.First();
        p.Last();
        p.Previous();
        p.Cancel();
        p.con.getHasPrevious();
        p.con.getHasNext();
        p.con.getPageNumber();
        boolean test1 = p.hasNext;
        boolean test2 = p.hasPrevious;
        integer test3 = p.pageNumber;   
        PageReference pageRef = p.refreshPageSize();   
        PageReference pageRef2 = p.processSelected(); 
     //   PageReference pageRef3 = p.processSelected2();          
        
        test.startTest();
        System.assertEquals( Dxx[0].CONSUMER__c,accct .id);
        System.assertEquals( Dxx[2].CONSUMER__c,accct .id); 
  //    PageReference pageRef5 = p.processSelected2();
  //    PageReference pageRef4 = p.processSelected3();   
        test.stopTest();
  //    PageReference pageRef5 = p.processSelected2();
//      PageReference pageRef4 = p.processSelected3(); 
     // PageReference pageRef = Page.AutomatedCallList;
     // Test.setCurrentPage(pageRef);
       
     
    }
   }