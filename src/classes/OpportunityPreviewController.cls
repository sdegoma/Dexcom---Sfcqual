/****************************************************
 * @author      : Kingsley Tumaneng
 * @date        : NOV 23, 2015
 * @description : OpportunityPreview Page controller
 * @Modified by : Noy De Goma@CSHERPAS on 01.21.2016
                 //---- Removed the reference for Oracle_Account_NUM__c
                 //---- Reverted back to original
****************************************************/
public class OpportunityPreviewController {
    public List<OpportunityLineItem> oppLineItemList {get; set;}
    public List<String> notPassedList {get; set;}
    public List<String> passedList {get; set;}
    public List<String> warningList {get; set;}
    public List<Benefits__c> benefitList {get; set;}
    public Opportunity oppTemp {get; set;}
    public String shipToAddress {get; set;}
    public String billToAddress {get; set;}
    private Id oppId;
    public string copayPrice{get;set;}
    public string copayMsg {get;set;}
    public string ccUrl {get;set;}
    //public boolean recalculating {get;set;}
    
    
    public String shipToAddressId {get; set;}
    public Map<Id, Address__c> mapAddress = new Map<Id, Address__c>();
        
    public boolean waiveShipping {get;set;}     //Used for Waive Shipping Charges-inputchecbox field
    public date schedShipDate {get;set;}        //Used for Shedule Shipping Date- Input Date
    public boolean schedShipDateMsg {get;set;}  //Used to render error message when schedShipDatedate is not in the future
    public string shippingAmount {get;set;}     //Used for Shipping Amount- OutputText
    public string totalAmount {get;set;}        //Used for Total Amount - OutputText
    
    public String shippingNotes {get; set;}     // used for Shipping notes
    public List<SelectOption> shipToAddressList {get; set;}
    public Boolean taxExempt {get; set;}
    public String taxAmount {get; set;}
    
    public String myOracleUserName = '';
    public Boolean signatureReq {get; set;}
    /********************************************
     * author       : Kingsley Tumaneng
     * date         : NOV 23 2015
     * param(s)     : Opportunity StandardController
     * return(s)    : 
     * description  : constructor
     * revision(s)  :
    ********************************************/
    public OpportunityPreviewController(ApexPages.StandardController std){
        this.oppId = ApexPages.currentPage().getParameters().get('id');
        oppLineItemList = new List<OpportunityLineItem>();
        List<String> bnfHierarchy = new List<String>();
        Set<Id> accId = new Set<Id>();
        notPassedList = new List<String>();
        passedList = new List<String>();
        warningList = new List<String>();
        oppTemp = new Opportunity();
        benefitList = new List<Benefits__c>();
        
        creditcardUrl__c ccSetting = creditcardUrl__c.getInstance();
        ccUrl = ccSetting.Url__c;
        
        //for Opportunity Line Item record
        for(OpportunityLineItem oppLineItem : [SELECT Id, 
                                                      Product2.Name,
                                                      Quantity,
                                                      UnitPrice,
                                                      Description
                                                      FROM OpportunityLineItem WHERE OpportunityId =: oppId]){
                                                         
            oppLineItemList.add(oppLineItem);
        }
        
        //get user Oracle_User_Name__c 
        myOracleUserName = [Select Oracle_User_Name__c From User Where Id = :UserInfo.getUserId()][0].Oracle_User_Name__c;
        
        //for Opportunity record details
        String accountId = '';
        for(Opportunity opp : [SELECT Id, 
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
                                      Account.Payor__c,
                                      Account.Party_ID__c,
                                      Account.BillingAddress,
                                      Account.ShippingAddress,
                                      Account.Inactive__c,
                                      Account.Prescribers__c,
                                      Account.Prescribers__r.Inactive__c,
                                      Account.Medical_Facility__c,
                                      Account.Medical_Facility__r.Inactive__c,
                                      Account.Oracle_Account_NUM__c,
                                      Account.AccountNumber,
                                      Account.County__c,
                                      TotalOpportunityQuantity,
                                      Pricebook2.Name,
                                      Pricebook2.Oracle_Id__c,
                                      Shipping_Method__c,
                                      HasAllDocs__c,
                                      Amount,
                                      Shipping_Signature_Required__c,
                                      Oracle_Account_NUM__c,
                                      Order_NUM__c,
                                      Existing_Consumer_Opp__c,
                                      Account.Type_of_Insulin_Therapy__c,
                                      Pricebook2.Cash_Price_Book__c
                                      FROM Opportunity WHERE Id =: oppid]){
            
            oppTemp = opp;
            accId.add(opp.AccountId);
            accountId = opp.AccountId;
            
                
            if(opp.Pricebook2.Cash_Price_Book__c){
                Decimal oppAmount = opp.Amount == null ? 0 : opp.Amount;
                copayPrice = String.valueOf((oppAmount).setScale(2));
            }
            
            if(opp.Order_NUM__c != null){
                notpassedList.add('Opportunity already has an Oracle order number associated with it');
            }else{
                passedList.add('No Oracle order yet created for Opportunity');
            }
            
            if(opp.Account.Party_ID__c == null){
                notPassedList.add('Customer account has not been created in Oracle');
            }else{
                passedList.add('Account has a Party Id');
            }
            
            if(!opp.Pricebook2.Cash_Price_Book__c){
                if(opp.Account.Payor__c == null){
                    notPassedList.add('Account must have a Payor');
                }else{
                    passedList.add('Account has a Payor');
                    if(opp.Account.Inactive__c){
                        notPassedList.add('Account Payor must be Active');
                    }else{
                        passedList.add('Account Payor is active');
                    }
                }   
            }
            
            
            if(opp.Account.Prescribers__c == null){
                notPassedList.add('Account Prescriber is null');
            }else{
                if(opp.Account.Prescribers__r.Inactive__c){
                    notPassedList.add('Account Prescriber must be Active');
                }else{
                    passedList.add('Account Prescriber is Active');
                }
            }
            
            /* 03/25/2016 
            if(opp.Account.Medical_Facility__c == null){
                notPassedList.add('Account Medical Facility is null');
            }else{
                if(opp.Account.Medical_Facility__r.Inactive__c){
                    notPassedList.add('Account Medical Facility must be Active');
                }else{
                    passedList.add('Account Medical Facility is Active');
                }
            }
            */
            
            
            if(opp.Account.BillingStreet == null || opp.Account.BillingCity == null || opp.Account.BillingState == null || opp.Account.BillingPostalCode == null){
                notPassedList.add('Account must have a Billing Address');
            }else{
                billToAddress = opp.Account.BillingStreet + '<br/>' + opp.Account.BillingCity + ', ' + opp.Account.BillingState + ' ' + opp.Account.BillingPostalCode + '<br/>' + opp.Account.BillingCountry;
                passedList.add('Account has a Billing Address'); 
            }
            
            if(opp.Account.ShippingStreet == null || opp.Account.ShippingCity == null || opp.Account.ShippingState == null || opp.Account.ShippingPostalCode == null){
                notPassedList.add('Account must have a Shipping Address');
            }else{
                shipToAddress = opp.Account.ShippingStreet + '<br/>' + opp.Account.ShippingCity + ', ' + opp.Account.ShippingState + ' ' + opp.Account.ShippingPostalCode + '<br/>' + opp.Account.ShippingCountry;
                passedList.add('Account has a Shipping Address'); 
            }
            
            if(opp.TotalOpportunityQuantity == null || opp.TotalOpportunityQuantity == 0){
                notPassedList.add('Quantity cannot be null');
            }else{
                passedList.add('Quantity is not null');
            }
            
            if(!opp.HasAllDocs__c  && !opp.Pricebook2.Cash_Price_Book__c){
                notPassedList.add('All required documents not yet collected or approved');  //was temporarily disabled for testing
            }else{
                passedList.add('All required documents have been approved');
            }
            
            if(opp.Existing_Consumer_Opp__c == 'Yes' && opp.Account.Type_of_Insulin_Therapy__c == null){
                notPassedList.add('Order for new consumer cannot be placed until Type of Insulin Therapy is specified');
            }
        }
        
        
        //for Benefit records  //refactored to include lastModifiedBy Validation
        String s = '';
        String reqBodyBenefit = '';
        boolean withPrimaryBenefits = false;
        for(Benefits__c bnf : [SELECT Id, Name,
                               Benefit_Hierarchy__c,
                               Payor__c,
                               Start_Date__c,
                               LastModifiedById,
                               CO_PAY__c,
                               INDIVIDUAL_DEDUCTIBLE__c,
                               INDIVIDUAL_MET__c,
                               Family_Met__c,  
                               INDIVIDUAL_OOP_MAX__c,
                               FAMILY_DEDUCT__c,
                               FAMILY_OOP_MAX__c,
                               Coverage__c
                               FROM Benefits__c WHERE Account__c IN : accId]){
                               
            benefitList.add(bnf);
            bnfHierarchy.add(bnf.Benefit_Hierarchy__c);
            s += bnf.Benefit_Hierarchy__c;
            
            if(bnf.Benefit_Hierarchy__c == 'Primary' && bnf.LastModifiedById =='00540000001y3kO'){
                withPrimaryBenefits = true;
            }
            
            if(bnf.Benefit_Hierarchy__c == 'Primary'){
                //for Benefit json request body
                reqBodyBenefit = '{"CopayAmount":"' + Integer.valueOf(bnf.CO_PAY__c) + 
                                  '","IndividualDeductable":"' + bnf.INDIVIDUAL_DEDUCTIBLE__c + 
                                  '","IndividualMet":"' + bnf.INDIVIDUAL_MET__c + 
                                  '","FamilyDeductable":"' + bnf.FAMILY_DEDUCT__c + 
                                  '","FamilyMet":"' + bnf.Family_Met__c + 
                                  '","Coverage":"' + bnf.Coverage__c + '"}';
                
                //end Benefit request body
            }
        } 
        
        //***************************************************//
        //START revision for new Copay webservice callout//
            //credit card url - Start - Kingsley - JAN 18 2015
            //Updated by Noy De Goma@CSHERPAS on 01.25.2016 - reverse the order of account num and oracle user name
            ccUrl = ccUrl + myOracleUserName + '/' + String.valueOf(oppTemp.Oracle_Account_NUM__c);
            //credit card url - End
            
            //copay Callout - Start - HMG -added Dec.16.2015
            copayPrice = '0';      
            if(oppTemp.Account.AccountNumber != null && oppTemp.Amount != null && oppTemp.Amount != 0){
                if(!oppTemp.Pricebook2.Cash_Price_Book__c){
                    copayUrl__c CopUrl = copayUrl__c.getInstance();
                    string tempUrl = copURL.Copay__c;
                    // tempUrl = tempUrl + string.valueof(oppTemp.Account.AccountNumber) + '/' + string.valueof(oppTemp.Amount) +'/';
                    //Return Value of the Callout
                    system.debug('***tempUrl = ' + tempUrl);
                    
                    //START request parameter
                    String reqBody = '{"AccountNumber":"' + oppTemp.Account.AccountNumber + 
                                      '","OrderTotalPrice":"' + string.valueOf(oppTemp.Amount) + 
                                      '","Benefits":' + reqBodyBenefit + '}';
                    system.debug('\n\nreqBody Copay = ' + reqBody + '\n\n');
                    //END request parameter
                    
                    map<string,string> cResults =  CopayServiceCall.getCalloutResponseContents(tempUrl, reqBody);
                    system.debug('***********cResults*************** ' + cResults);
                    //Prevent Null Pointer Exception
                    if(cResults != null){
                        if(cResults.Containskey('CopayPrice')){
                            copayPrice =  String.valueOf(Decimal.valueOf(cResults.get('CopayPrice')).setScale(2));
                        }
                        if(cResults.containsKey('STATUS')){
                            copayMsg = cResults.get('STATUS');
                        }else if(cResults.containsKey('ResponseCode')){
                            if(String.valueOf(cResults.get('ResponseCode')) == '1'){
                                copayMsg = 'Success';
                            }else{
                                copayMsg =  'Error calling copay service ' + (cResults.get('Message') == null ? '' : cResults.get('Message'));
                            }
                            
                        }
                    }
                }
                else{
                    copayMsg = 'Cash Pricelist, No copay calculated';
                    Decimal oppAmount = oppTemp.Amount == null ? 0 : oppTemp.Amount;
                    copayPrice = String.valueOf((oppAmount).setScale(2));
                }
            }
            else{
                copayMsg = 'Oracle account number is blank or total order amount is zero';
            }
            //copay Callout - End  
        //***************************************************//
        
        /*if(!s.containsIgnoreCase('Primary')){
            notPassedList.add('Primary Benefit is required');
        }else{
            passedList.add('There is a Primary Benefit');
        }*/
        if(copayMsg != 'Success' && !oppTemp.Pricebook2.Cash_Price_Book__c){
            //not cash order and copay was not calculated
            notPassedList.add('Insurance order, but no copay calculated');
        }else{
            passedList.add('Copay calculated or is cash order');
        }
        
        // if(withPrimaryBenefits || oppTemp.Pricebook2.Name == 'Cash Price List'){
        //   passedList.add('There is a Primary Benefit or is Cash price list');
        // }else{            
        //   notPassedList.add('Please add a primary benefit record and confirm that this record has synced with Oracle');
        // }
        //END of Refactoring
        
        signatureReq = oppTemp.Shipping_Signature_Required__c;
        schedShipDateMsg = false;
        waiveShipping = false;
        //shippingAmount = '0';
        //if()
        totalAmount  = '0';
        taxAmount = '100';
        taxExempt = false;
        
        calculateShippingAmnt();

        checkAccountAddress(accountId);
        
        calculateTaxAmount();
        system.debug('*********************** Tax Amount ********************** ' + taxAmount);
        if(oppTemp.Pricebook2.Cash_Price_Book__c){
            if(taxAmount == '0.00' && !taxExempt){
                warningList.add('Tax Amount was not calculated');
            }else if(Decimal.valueOf(taxAmount) < 0){
                warningList.add('Tax not calculated for the provided data');

            }
        }
        
        if(notPassedList.size() != 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Some data has not passed validation. You are not yet able to submit the Order.'));
        }  
    }//End of Constructor
    
    /********************************************
     * author       : Hilario Galindez
     * date         : Dec 23 2015
     * param(s)     : 
     * return(s)    : 
     * description  : Method to Calculate Shipping Amount
     * revision(s)  :
    ********************************************/
    
    public pagereference calculateShippingAmnt(){
        
        shippingAmount = '0';
        if(!waiveShipping){
            if(oppTemp !=null){
                if(oppTemp.Shipping_Method__c != null){
                    
                    if(!oppTemp.Pricebook2.Cash_Price_Book__c){
                      if(oppTemp.Shipping_Method__c == '000001_FEDEX_A_3DS - FedEx Air Express Saver 3 Day Afternoon - $15' || oppTemp.Shipping_Method__c == '000001_FEDEX_L_GND - FedEx Ground Home Delivery - $5'){
                           //shippingAmount = '0';
                      }else{
                        if(!String.isEmpty(oppTemp.Shipping_Method__c.substringAfterlast('$'))){
                            shippingAmount =  oppTemp.Shipping_Method__c.substringAfterlast('$');
                        }else{
                            shippingAmount = '0';
                        }
                        System.debug('******** oppTemp.Shipping_Method__c ************* ' + oppTemp.Shipping_Method__c);
                        System.debug('******** shippingAmount ************* ' + shippingAmount);
                        Integer iShipAmount = Integer.valueOf(shippingAmount);
                        iShipAmount = iShipAmount -15;
                        shippingAmount = String.valueOf(iShipAmount);
                      }    
                    }else{
                      shippingAmount =  oppTemp.Shipping_Method__c.substringAfterlast('$');

                    }
                }
            }
        }
        CalculateTotalAmnt();
        return null;
    }

    /********************************************
     * author       : Hilario Galindez
     * date         : Dec 23 2015
     * param(s)     : 
     * return(s)    : 
     * description  : Method to Calculate Total Amount
     * revision(s)  :
    ********************************************/
    
    
    public pagereference CalculateTotalAmnt(){
        
        decimal sAmount;
        decimal tAmount;
        decimal oppAmount = oppTemp.Amount == null ? 0 : oppTemp.Amount;
        if(String.isEmpty(shippingAmount)){
            sAmount = decimal.valueOf(0).setScale(1);
        }else{
            sAmount = decimal.valueOf(shippingAmount) >= 1 ? ((decimal.valueof(shippingAmount)/decimal.valueof(shippingAmount).setScale(0)) == 1 ? decimal.valueof(shippingAmount).setScale(1) : decimal.valueof(shippingAmount)) : (decimal.valueOf(shippingAmount) > 0 ? decimal.valueOf(shippingAmount) :decimal.valueOf(0).setScale(1));
        }
        
        if(String.isEmpty(taxAmount)){
            tAmount = decimal.valueOf(0).setScale(1);
        }else{
            tAmount = decimal.valueOf(taxAmount) >= 1 ? ((decimal.valueof(taxAmount)/decimal.valueof(taxAmount).setScale(0)) == 1 ? decimal.valueof(taxAmount).setScale(1) : decimal.valueof(taxAmount)) : (decimal.valueOf(taxAmount) > 0 ? decimal.valueOf(taxAmount) : decimal.valueOf(0).setScale(1));
        }
        
       if(oppTemp.Pricebook2.Cash_Price_Book__c){
            // commented out by Noy De Goma@CSHERPAS on 02.10.2016
            // resulting to an error if the taxAmount or shipingAmount already have a decimal place(s)
            //totalAmount = string.valueof(oppTemp.Amount + decimal.valueof(shippingAmount + '.0') + decimal.valueOf(taxAmount + '.0'));
            totalAmount = string.valueof((oppAmount + sAmount + tAmount).setScale(2));
        }else{
            // commented out by Noy De Goma@CSHERPAS on 02.10.2016
            // resulting to an error if the taxAmount or shipingAmount already have a decimal place(s)
            //totalAmount = string.valueof(decimal.valueof(copayPrice) + decimal.valueof(shippingAmount + '.0') + decimal.valueOf(taxAmount + '.0'));
            totalAmount = string.valueof((decimal.valueof(copayPrice) + sAmount + tAmount).setScale(2));
        }    
        return null;
    }
    public pagereference validateSchedShipDate(){
        if(schedShipDate != null){
            if(schedShipDate < system.date.today()){
                schedShipDateMsg = true;
            }else{
                schedShipDateMsg = false;
            }
        }
        return null;
    }

    /********************************************
     * author       : Kingsley Tumaneng
     * date         : NOV 23 2015
     * param(s)     : PageReference
     * return(s)    : 
     * description  : Method to submit Opportunity
     * revision(s)  :
    ********************************************/
    public PageReference submitButton(){
        PageReference pageRef = new PageReference('/'+oppId);
        if(mapAddress.get(shipToAddressId).Oracle_Address_ID__c != null){
           //for getting the code on Shipping method
            List<String> tempSplitted = oppTemp.Shipping_Method__c.split('-');
            String splittedStr = tempSplitted[0].trim();
            
            List<String> orderItemList = new List<String>();
            String orderItem = '';
            String schedDate;
            system.debug('\n\n***schedShipDate = ' + schedShipDate + '\n\n');
            if(schedShipDate != null){
                Datetime newDT = datetime.newInstance(schedShipDate.year(), schedShipDate.month(),schedShipDate.day());
                schedDate = newDT.format('MM/dd/yyyy'); 
            }else{
                DateTime dT = system.today().addDays(1);
                schedDate = dT.format('MM/dd/yyyy'); 
            }
            system.debug('\n\n***myDate= ' + schedDate + '\n\n');
            //for getting opportunity line item
            for(OpportunityLineItem oppLineItem : oppLineItemList){
                orderItemList.add('{"SKU":"' + oppLineItem.Product2.Name + 
                            '","Quantity":"' + Integer.valueOf(oppLineItem.Quantity) +'"}');
            }
            
            String signReq = 'N';
            if(signatureReq){
                signReq = 'Y';
            }
            
            String waiveShip = 'N';
            if(waiveShipping){
                waiveShip = 'Y';
            }
            
            String taxEx = 'N';
            if(taxExempt){
                taxEx = 'Y';
            }
            
            orderItem =string.join(orderItemList,',');
            System.debug('\n\n***Shipping_Signature_Required__c = ' + oppTemp.Shipping_Signature_Required__c + '\n\n');
            
            //building json string to pass in Oracle
            String param = '{"UserName":"' + myOracleUserName +
                            '","AccountNumber":"' + oppTemp.Account.AccountNumber + 
                            '","ShippingMethod":"' + splittedStr +  
                            '","SignatureRequired":"' + signReq +
                            '","ScheduledShipDate":"' + schedDate + 
                            '","ShippingAddressId":"' + mapAddress.get(shipToAddressId).Oracle_Address_ID__c +
                            '","ShippingNotes":"' + shippingNotes +
                            '","PriceListId":"' + oppTemp.Pricebook2.Oracle_Id__c +
                            '","WaiveShippingCharge":"' + waiveShip + 
                            '","TaxExempt":"' + taxEx + 
                            '","OrderLines":[' + orderItem + ']}';
                            
            System.debug('***orderItem = \n' + orderItem +'\n'); 
            System.debug('====Create order JSON ====: ' + param);    
            
            CreateOrder__c createOrder = CreateOrder__c.getInstance();
            String url = createOrder.Create_Order_URL__c;
            map<string,string> cResults =  CreateOrderServiceCall.getCalloutResponseContents(url, param);
            System.debug('***********URLCREATEORDER************* ' + url);
            System.debug('\n\n*******cResultsCreateOrder****** ' + cResults);
            if(cResults != null){
                if (cResults.containsKey('ResponseCode')){
                    System.debug('\n\n*******INSIDE ****** ');
                    if(cResults.get('ResponseCode') == '1'){
                        oppTemp.Order_NUM__c = cResults.get('OrderNumber');
                        oppTemp.StageName = '61. Quote Approved';
                        oppTemp.Close_Reason__c = 'Converted to Sale (DME)';
                        oppTemp.Status__c = null;
                        update oppTemp;
                        System.debug('\n\n*******INSIDE UPDATE****** ');
                    }else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in calling webservice: ' + cResults.get('Message')));
                        pageRef = null;
                    }
                }else if(cResults.containsKey('STATUS')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in calling webservice: ' + cResults.get('STATUS')));
                    pageRef = null;
                }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error in calling webservice: No Results found'));
                pageRef = null;
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The shipping address you have selected does not have an Oracle Address Id. It does not appear to be synced with Oracle'));
            pageRef = null;
        }
        return pageRef;
    }
    
    /********************************************
     * author       : Kingsley Tumaneng
     * date         : NOV 23 2015
     * param(s)     : PageReference
     * return(s)    : 
     * description  : Method to return on 
     *                Opportunity record
     * revision(s)  :
    ********************************************/
    public PageReference cancelButton(){
        PageReference pageRef = new PageReference('/'+oppId);
        return pageRef;
    }
    
    /********************************************
     * author       : Kingsley Tumaneng
     * date         : JAN 6 2016
     * param(s)     : 
     * return(s)    : 
     * description  : 
     * revision(s)  :
    ********************************************/
    public void checkAccountAddress(Id accId){
        shipToAddressList = new List<SelectOption>();
        for(Address__c addrs : [SELECT Id, 
                                       Street_Address_1__c, 
                                       State__c, 
                                       Zip_Postal_Code__c, 
                                       City__c, 
                                       Address_Type__c, 
                                       County__c,
                                       Site_ID__c,
                                       Oracle_Address_ID__c,
                                       Primary_Flag__c FROM Address__c WHERE Address_Type__c =: 'SHIP_TO' AND Account__c =: accId]){
            if(addrs.Primary_Flag__c){
                shipToAddressList.add(new SelectOption(addrs.Id, addrs.Street_Address_1__c + ' ' + addrs.City__c + ', ' + addrs.State__c + ' ' + addrs.Zip_Postal_Code__c + ' ' + addrs.County__c));
                shipToAddressId = addrs.Id;
            }else{
                shipToAddressList.add(new SelectOption(addrs.Id, addrs.Street_Address_1__c + ' ' + addrs.City__c + ', ' + addrs.State__c + ' ' + addrs.Zip_Postal_Code__c + ' ' + addrs.County__c));
            }
            mapAddress.put(addrs.Id, addrs);
        }
    }
    
    public PageReference recalculateTax(){
        calculateTaxAmount();
        
        if(!warningList.isEmpty()){
            if(warningList.get(warningList.size() - 1) == 'Tax Amount was not calculated'){
                warningList.remove(warningList.size() - 1);
            }
        }
        
        if(oppTemp.Pricebook2.Cash_Price_Book__c){
            if(taxAmount == '0.00' && !taxExempt){
                warningList.add('Tax Amount was not calculated');
                //Tax Amount was not calculated
            }else if(decimal.valueOf(taxAmount) < 0){
                warningList.add('Tax not calculated for the provided data');

            }
        }
        
        
        system.debug('***** notPassedList ***** ' +  notPassedList);
        
        if(notPassedList.size() != 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Some data has not passed validation. You are not yet able to submit the Order.'));
        }
        
        return null;
    }
    
    public PageReference calculateTaxAmount(){
        taxAmount = '0';
        if(oppTemp.Pricebook2.Cash_Price_Book__c){
            if(!taxExempt){
                if(oppTemp != null){
                    Decimal oppAmount = oppTemp.Amount == null ? 0 : oppTemp.Amount;
                    /*list<Address__c> address = [SELECT Id, City__c, State__c, County__c, Zip_Postal_Code__c FROM Address__c WHERE Id = :shipToAddressId];
                    
                    if(address.isEmpty()){
                        address.add(new Address__c());
                    }*/
                    Address__c add = new Address__c();
                    if(mapAddress.containsKey(shipToAddressId)){
                        add = mapAddress.get(shipToAddressId);
                    }
                    //Address__c add = address[0];
                    
                    //if(oppTemp.Account.ShippingPostalCode != null && oppTemp.Account.County__c != null){
                    if(add.Zip_Postal_Code__c != null && add.County__c != null){
                        TaxComputationUrl__c taxCompUrl = TaxComputationUrl__c.getInstance();
                        //String postalCode = (oppTemp.Account.ShippingPostalCode).length() > 5 ? (oppTemp.Account.ShippingPostalCode).substring(0,5) : (oppTemp.Account.ShippingPostalCode);
                        String postalCode = (add.Zip_Postal_Code__c).length() > 5 ? (add.Zip_Postal_Code__c).substring(0,5) : (add.Zip_Postal_Code__c);
                        /*String url = taxCompUrl.URL__c  + oppTemp.Pricebook2.Oracle_ID__c + '/' + oppTemp.Amount + '/' + (oppTemp.Account.ShippingCity).replace(' ', '%20') +
                                    '/' + (oppTemp.Account.ShippingState).replace(' ', '%20') + '/' + (oppTemp.Account.County__c).replace(' ', '%20') + '/' + postalCode;*/
                                    String url = taxCompUrl.URL__c  + oppTemp.Pricebook2.Oracle_ID__c + '/' + oppAmount  + '/' + (add.City__c).replace(' ', '%20') +
                                    '/' + (add.State__c).replace(' ', '%20') + '/' + (add.County__c).replace(' ', '%20') + '/' + postalCode;
                        map<string,string> cResults =  TaxServiceCall.getCalloutResponseContents(url);
                        System.debug('***********URL*************Tax ' + url);
                        System.debug('\n\n*******cResults******Tax ' + cResults);
                        if(cResults != null){
                            if (cResults.containsKey('ResponseCode')){
                                if(cResults.get('ResponseCode') == '1'){
                                    if(cResults.Containskey('TaxAmount')){
                                        if(cResults.get('Message')!='null'){
                                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'' +  cResults.get('Message')));
                                        }else{
                                            taxAmount = String.valueOf(decimal.valueOf(cResults.get('TaxAmount')).setScale(2));
                                        }
                                    }
                                }
                                //scottie added 02.26.2016
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'' +  cResults.get('Message')));
                                }
                                
                            }else if(cResults.containsKey('STATUS')){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error in calling webservice: ' + cResults.get('STATUS')));
                            }
                        }
                    }else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to compute for the tax. Account\'s ShippingPostalCode and Account\'s County should not be null.'));
                    }
                }
            }else{
                    taxAmount = '0.00';
            }
        }
        else{
            taxAmount = '0.00';
        }
        CalculateTotalAmnt();
        return null;
    }
}