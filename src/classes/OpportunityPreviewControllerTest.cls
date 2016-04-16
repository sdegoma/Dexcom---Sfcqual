@isTest
private class OpportunityPreviewControllerTest { 

    @testSetup static void setup() { 
      
      TaxComputationUrl__c co = new TaxComputationUrl__c(
      URL__c = 'https://dexsfd.dexcom.com/api/orders/calculatetax/'
    );
    insert co;
      
      CreateOrder__c createOrder = new CreateOrder__c(
      Create_Order_URL__c = 'https://dexsfd.dexcom.com/api/orders/createorder/'
    );
    insert createOrder;
    
        Id recIdConsumer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        Account accConsumer = TestDataBuilder.getAccountListConsumer(1, recIdConsumer)[0];
            accConsumer.Secondary_Plan_Name__c = 'Test';
          accConsumer.ShippingCity = 'Test';
          accConsumer.ShippingState = 'Test';
          accConsumer.County__c = 'Test';
          accConsumer.ShippingPostalCode = '1';
            insert accConsumer;
        
        Id recIdPayor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
        Account accPayor = TestDataBuilder.getAccountList(1, recIdPayor)[0];
            accPayor.Secondary_Plan_Name__c = 'Payor test';
            insert accPayor;
        
        Id recIdMedFac = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Medical Facility').getRecordTypeId();
        Account accMedFac = TestDataBuilder.getAccountList(1, recIdMedFac)[0];
            accMedFac.Secondary_Plan_Name__c = 'Med Fac test';
            insert accMedFac;
            
        Id recIdPres = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prescriber').getRecordTypeId();
        Account accPresc = TestDataBuilder.getAccountListConsumer(1, recIdPres)[0];
            accPresc.Secondary_Plan_Name__c = 'Pres test';
            insert accPresc;
            
        Opportunity opp = TestDataBuilder.getOpportunityList(1, accConsumer.Id, accPayor.Id)[0];
            insert opp;
        
        Id recIdBenefit = Schema.SObjectType.Benefits__c.getRecordTypeInfosByName().get('Benefits').getRecordTypeId();
        
        Benefits__c benef = TestDataBuilder.getBenefits(accConsumer.Id, opp.Payor__c, 1, 'Primary', recIdBenefit)[0];
            insert benef;
        
        Address__c addrs = TestDataBuilder.getAddressList(accConsumer.Id, true, 'SHIP_TO', 1)[0];
            insert addrs;
            
        Address__c addrsNotPrimary = TestDataBuilder.getAddressList(accConsumer.Id, false, 'SHIP_TO', 1)[0];
            insert addrsNotPrimary;
    }
    
    @isTest static void testConstructor(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        Test.setMock(HttpCalloutMock.class, new copayCalloutTest());
        System.runAs( thisUser ){
                test.startTest();
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = 'test BillingStreet'; 
                    accList[0].BillingState = 'test BillingState'; 
                    accList[0].BillingCity = 'test BillingCity'; 
                    accList[0].BillingCountry = 'test BillingCountry'; 
                    accList[0].BillingPostalCode = 'zip';
                    accList[0].ShippingStreet = 'test ShippingStreet'; 
                    accList[0].ShippingState = 'test ShippingState'; 
                    accList[0].ShippingCity = 'test ShippingCity'; 
                    accList[0].ShippingCountry = 'test ShippingCountry'; 
                    accList[0].ShippingPostalCode = 'zip';
                    accList[0].Party_ID__c = '1234';
                    accList[0].Medical_Facility__c = null;
                    accList[0].Prescribers__c = null;
                    accList[0].Oracle_Account_NUM__c = 242117;
                    accList[0].Inactive__c = true;
                    accList[0].AccountNumber = '1234';
                update accList;
                
                Pricebook2 pb = new Pricebook2(Name='Blue Cross Blue Shield of Illinois', isActive=true);
                    insert pb;
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    Account.Oracle_Account_NUM__c,
                                                    Amount,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                    
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 597.08);
                insert oppLineItem;
                
                oppList[0].HasAllDocs__c = true;
                oppList[0].Pricebook2Id = pb.Id;
                oppList[0].Amount = 1;
                oppList[0].Shipping_Method__c = '000001_FEDEX_A_3DS - FedEx Air Express Saver 3 Day Afternoon - $15';
                    update oppList[0];
                
                List<OpportunityLineItem> oppLineItemList = [SELECT Id, 
                                                                    Product2.Name,
                                                                    Quantity,
                                                                    UnitPrice,
                                                                    Description
                                                                    FROM OpportunityLineItem WHERE Id =: oppLineItem.Id];          
                
                List<Benefits__c> benefList = [SELECT Id, 
                                                      Name,
                                                      Benefit_Hierarchy__c,
                                                      Payor__c,
                                                      Start_Date__c 
                                                      FROM Benefits__c WHERE Account__c =: oppList[0].AccountId];  
            
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                
                testController.shippingNotes = 'test';
                testController.schedShipDate = date.today();
                testController.validateSchedShipDate();
                testController.cancelButton();
            test.stopTest();
        }
    }
    
    @isTest static void testFieldsAreNull(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs( thisUser ){
            test.startTest();
                List<Account> accMedFac = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Med Fac Test'];
                    accMedFac[0].Inactive__c = true;
                update accMedFac;
                
                List<Account> accPres = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Pres test'];
                    accPres[0].Inactive__c = true;
                update accPres;
                
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Medical_Facility__c = accMedFac[0].Id;
                    accList[0].Prescribers__c = accPres[0].Id;
                    accList[0].Inactive__c = true;
                    
                update accList;
                
                List<Account> accPayorList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Payor test'];
                    accPayorList[0].Inactive__c = true;
                update accPayorList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Cash_Price_Book__c = true);
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];       
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 597.00);
                insert oppLineItem;
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                
                testController.schedShipDate = date.today().addDays(356);
                testController.validateSchedShipDate();
                testController.cancelButton();
            test.stopTest();
        }
    }
    
    @isTest static void testAccountInactive(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs( thisUser ){
            test.startTest();
                List<Account> accMedFac = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Med Fac Test'];
                    accMedFac[0].Inactive__c = false;
                update accMedFac;
                
                List<Account> accPres = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Pres test'];
                    accPres[0].Inactive__c = false;
                update accPres;
                
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Medical_Facility__c = accMedFac[0].Id;
                    accList[0].Prescribers__c = accPres[0].Id;
                    accList[0].Inactive__c = false;
                    
                update accList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Cash_Price_Book__c = true);
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];       
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 597.00);
                insert oppLineItem;
                List<Address__c> addrsList = [SELECT Id, Primary_Flag__c FROM Address__c WHERE Address_Type__c =: 'SHIP_TO'];
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                
        }
    }
    
    @isTest static void testTotalAmmountIsZero(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        
        
        
        System.runAs( thisUser ){
            test.startTest();
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: accList[0].Id];
                List<Address__c> addrsList = [SELECT Id, Primary_Flag__c FROM Address__c WHERE Address_Type__c =: 'SHIP_TO'];
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                
            test.stopTest();
        }
    }
    
    
    @isTest static void testTaxComputationSuccess(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
                test.startTest();    
                update accList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Oracle_Id__c = '1234', Cash_Price_Book__c = true);
                
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];      
                
                list<Address__c> addressList = [SELECT id, City__c, County__c, State__c, Zip_Postal_Code__c FROM Address__c WHERE Account__c = : oppList[0].AccountId AND Primary_Flag__c = true AND Address_Type__c = 'SHIP_TO']; 
                
                if(!addressList.isEmpty()){
                  addressList[0].City__c = 'Test';
                  addressList[0].State__c = 'Test';
                  addressList[0].County__c = 'Test';
                  addressList[0].Zip_Postal_Code__c = '1';
                  
                  update addressList[0];
                }
                
                System.debug('\n\n****** Account ' + oppList[0].Account.county__c);
                System.debug('\n\n****** Account ' + oppList[0].Account.ShippingPostalCode);
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 100.00);
                insert oppLineItem;
        System.runAs( thisUser ){
            
                
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                

           
        }
         test.stopTest();
    }
    
     @isTest static void testTaxComputationFailed(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                accList[0].BillingStreet = null; 
                accList[0].BillingState = null; 
                accList[0].BillingCity = null; 
                accList[0].BillingCountry = null; 
                accList[0].BillingPostalCode = null;
                accList[0].ShippingStreet = null; 
                accList[0].ShippingState = null; 
                accList[0].ShippingCity = null; 
                accList[0].ShippingCountry = null; 
                accList[0].ShippingPostalCode = null;
                accList[0].Party_ID__c = null;
                accList[0].Payor__c = null;
                accList[0].Inactive__c = true;
            test.startTest();    
          update accList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Oracle_Id__c = '1234', Cash_Price_Book__c = true);
                
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];      
                
                list<Address__c> addressList = [SELECT id, City__c, County__c, State__c, Zip_Postal_Code__c FROM Address__c WHERE Account__c = : oppList[0].AccountId AND Primary_Flag__c = true AND Address_Type__c = 'SHIP_TO']; 
                
                if(!addressList.isEmpty()){
                  addressList[0].City__c = 'Test';
                  addressList[0].State__c = 'Test';
                  addressList[0].County__c = 'Test';
                  addressList[0].Zip_Postal_Code__c = '2';
                  
                  update addressList[0];
                }
                
                System.debug('\n\n****** Account ' + oppList[0].Account.county__c);
                System.debug('\n\n****** Account ' + oppList[0].Account.ShippingPostalCode);
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 100.00);
                insert oppLineItem;
          System.runAs( thisUser ){
            
                
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                testController.recalculateTax();
                testController.recalculateTax();
                

            
          }
        test.stopTest();
    }
    
    @isTest static void testTaxComputationGetResponseCode0(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
             test.startTest();       
                update accList;
                
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Oracle_Id__c = '1234', Cash_Price_Book__c = true);
                
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];      
                
                list<Address__c> addressList = [SELECT id, City__c, County__c, State__c, Zip_Postal_Code__c FROM Address__c WHERE Account__c = : oppList[0].AccountId AND Primary_Flag__c = true AND Address_Type__c = 'SHIP_TO']; 
                
                if(!addressList.isEmpty()){
                  addressList[0].City__c = 'Test';
                  addressList[0].State__c = 'Test';
                  addressList[0].County__c = 'Test';
                  addressList[0].Zip_Postal_Code__c = '3';
                  
                  update addressList[0];
                }
                
                
                System.debug('\n\n****** Account ' + oppList[0].Account.county__c);
                System.debug('\n\n****** Account ' + oppList[0].Account.ShippingPostalCode);
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 100.00);
                insert oppLineItem;
        System.runAs( thisUser ){
            
                
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                

            
        }
        test.stopTest();
    }
    @isTest static void testTaxComputation404(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
              test.startTest();      
                update accList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Oracle_Id__c = '1234', Cash_Price_Book__c = true);
                
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];      
                
                list<Address__c> addressList = [SELECT id, City__c, County__c, State__c, Zip_Postal_Code__c FROM Address__c WHERE Account__c = : oppList[0].AccountId AND Primary_Flag__c = true AND Address_Type__c = 'SHIP_TO']; 
                
                if(!addressList.isEmpty()){
                  addressList[0].City__c = 'Test';
                  addressList[0].State__c = 'Test';
                  addressList[0].County__c = 'Test';
                  addressList[0].Zip_Postal_Code__c = '4';
                  
                  update addressList[0];
                }

                
                System.debug('\n\n****** Account ' + oppList[0].Account.county__c);
                System.debug('\n\n****** Account ' + oppList[0].Account.ShippingPostalCode);
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 100.00);
                insert oppLineItem;
        System.runAs( thisUser ){
            
                
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                
                testController.taxExempt = true;
                testController.calculateTaxAmount();
                

            
        }
        test.stopTest();
    }
    
    @isTest static void testTaxComputationFailed2(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
              test.startTest();      
                update accList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Oracle_Id__c = '1234', Cash_Price_Book__c = true);
                
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Payor__c,
                                                    Expedited_Shipping__c,
                                                    Account.BillingStreet, 
                                                    Account.BillingState, 
                                                    Account.BillingCity, 
                                                    Account.BillingCountry, 
                                                    Account.BillingPostalCode,
                                                    Account.ShippingStreet, 
                                                    Account.ShippingState, 
                                                    Account.ShippingCity, 
                                                    Account.ShippingCountry, 
                                                    Account.ShippingPostalCode,
                                                    AccountId,
                                                    Account.County__c,
                                                    Account.Payor__c,
                                                    Account.Party_ID__c,
                                                    Account.BillingAddress,
                                                    Account.ShippingAddress,
                                                    TotalOpportunityQuantity,
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];      
                
                list<Address__c> addressList = [SELECT id, City__c, County__c, State__c, Zip_Postal_Code__c FROM Address__c WHERE Account__c = : oppList[0].AccountId AND Primary_Flag__c = true AND Address_Type__c = 'SHIP_TO']; 
                
                if(!addressList.isEmpty()){
                  addressList[0].City__c = 'Test';
                  addressList[0].State__c = 'Test';
                  addressList[0].County__c = 'Test';
                  addressList[0].Zip_Postal_Code__c = '5';
                  
                  update addressList[0];
                }

                
                System.debug('\n\n****** Account ' + oppList[0].Account.county__c);
                System.debug('\n\n****** Account ' + oppList[0].Account.ShippingPostalCode);
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 100.00);
                insert oppLineItem;
        System.runAs( thisUser ){
            
                
                
                PageReference pageRef = Page.OpportunityPreview;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                
                testController.taxExempt = true;
                testController.calculateTaxAmount();
                testController.recalculateTax();
                

            
        }
        test.stopTest();
    }
    
    @isTest static void testCreateOrder(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        Test.setMock(HttpCalloutMock.class, new CreateOrderCalloutTest());
        System.runAs( thisUser ){
                Address__c addrs = [SELECT Id, Primary_Flag__c, Oracle_Address_ID__c FROM Address__c WHERE Primary_Flag__c =: true];
                    addrs.Oracle_Address_ID__c = '';
                update addrs;
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null; 
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
                test.startTest();   
                update accList;
                
                List<Account> accPayorList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Payor test'];
                    accPayorList[0].Inactive__c = true;
                update accPayorList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Cash_Price_Book__c = true);
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];       
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 597.00);
                insert oppLineItem;
            
                    PageReference pageRef = Page.OpportunityPreview;
                    Test.setCurrentPage(pageRef);
                    ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                    ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                    OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                    
                    testController.submitButton();
            test.stopTest();
        }
    }
    
    @isTest static void testCreateOrderShipDateNotNull(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        Test.setMock(HttpCalloutMock.class, new CreateOrderCalloutTest());
        System.runAs( thisUser ){
                Address__c addrs = [SELECT Id, Primary_Flag__c, Oracle_Address_ID__c FROM Address__c WHERE Primary_Flag__c =: true];
                    addrs.Oracle_Address_ID__c = '1234';
                update addrs;
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
            test.startTest();        
                update accList;
                
                List<Account> accPayorList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Payor test'];
                    accPayorList[0].Inactive__c = true;
                update accPayorList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Cash_Price_Book__c = true);
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Signature_Required__c = true;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];       
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 597.00);
                insert oppLineItem;
            
                    PageReference pageRef = Page.OpportunityPreview;
                    Test.setCurrentPage(pageRef);
                    ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                    ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                    OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                    testController.schedShipDate = date.today().addDays(1);
                    testController.submitButton();
            test.stopTest();
        }
    }
    
    @isTest static void testCreateOrderAddressOracelNotNull(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        Test.setMock(HttpCalloutMock.class, new CreateOrderCalloutTest());
        System.runAs( thisUser ){
                Address__c addrs = [SELECT Id, Primary_Flag__c, Oracle_Address_ID__c FROM Address__c WHERE Primary_Flag__c =: true];
                    addrs.Oracle_Address_ID__c = '1234';
                update addrs;
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                    accList[0].BillingStreet = null; 
                    accList[0].BillingState = null; 
                    accList[0].BillingCity = null; 
                    accList[0].BillingCountry = null; 
                    accList[0].BillingPostalCode = null;
                    accList[0].ShippingStreet = null; 
                    accList[0].ShippingState = null; 
                    accList[0].ShippingCity = null; 
                    accList[0].ShippingCountry = null; 
                    accList[0].ShippingPostalCode = null;
                    accList[0].Party_ID__c = null;
                    accList[0].Payor__c = null;
                    accList[0].Inactive__c = true;
                test.startTest();
                update accList;
                
                List<Account> accPayorList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Payor test'];
                    accPayorList[0].Inactive__c = true;
                update accPayorList;
                
                Pricebook2 pb = new Pricebook2(Name='Cash Price List', isActive=true, Cash_Price_Book__c = true);
                    insert pb;
                    
                List<Opportunity> oppList = [SELECT Id, 
                                                    Pricebook2.Name,
                                                    Shipping_Method__c,
                                                    HasAllDocs__c FROM Opportunity WHERE AccountId =: accList[0].Id];
                
                    oppList[0].HasAllDocs__c = false;
                    oppList[0].Pricebook2Id = pb.Id;
                    oppList[0].Shipping_Method__c = '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5';
                update oppList[0];       
                
                OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItemCashPrice('1', 1, oppList[0].Id, pb.Id, 597.00);
                insert oppLineItem;
            
                    PageReference pageRef = Page.OpportunityPreview;
                    Test.setCurrentPage(pageRef);
                    ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                    ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                    OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                    testController.submitButton();
            test.stopTest();
           
        }
    }
    
    @isTest static void testCreateOrderResultNull(){
        User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        Test.setMock(HttpCalloutMock.class, new CreateOrderCalloutTest());
        System.runAs( thisUser ){
                Address__c addrs = [SELECT Id, Primary_Flag__c, Oracle_Address_ID__c FROM Address__c WHERE Primary_Flag__c =: true];
                    addrs.Oracle_Address_ID__c = '1234';
                update addrs;
                List<Account> accList = [SELECT Id FROM Account WHERE Secondary_Plan_Name__c =: 'Test'];
                
                List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: accList[0].Id];
            test.startTest();
                    PageReference pageRef = Page.OpportunityPreview;
                    Test.setCurrentPage(pageRef);
                    ApexPages.currentPage().getParameters().put('Id', oppList[0].id);
                    ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
                    OpportunityPreviewController testController = new OpportunityPreviewController(sc);
                    testController.waiveShipping = true;
                    testController.taxExempt = true;
                    testController.signatureReq = true;
                    testController.submitButton();
            test.stopTest();
        }
    }
}