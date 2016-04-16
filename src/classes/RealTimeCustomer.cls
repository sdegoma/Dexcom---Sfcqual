/***************************************
 * @author      : Kingsley Tumaneng
 * @date        : JAN 26, 2015
 * @description : Class to invoke webservice for
 *                Real Time Customer Integration
 *                via Web Service
***************************************/

global class RealTimeCustomer {
    webservice static String callIntegration(Id accId){
        String result = ''; 
        String CLASS_CODE = 'CONSUMER';
        String PARTY_TYPE = 'PERSON';
        Boolean isSuccess = false;
        String partyId = '';
        String accountNumber = '';
        
        try{
            List<Account> acc = [SELECT Id, 
                                        LastName, 
                                        FirstName, 
                                        AccountNumber, 
                                        Party_ID__c 
                                        FROM Account 
                                        WHERE Id =: accId LIMIT 1];
                                        
            String myOracleUserName = [SELECT Oracle_User_Name__c 
                                              FROM User 
                                              WHERE Id = :UserInfo.getUserId()][0].Oracle_User_Name__c;
            
            if(acc[0].Party_ID__c == null){ //only call web service is party id is null
            if(acc[0].Id != null && acc[0].FirstName != null && acc[0].LastName != null && myOracleUserName != null){
                String subStr = String.valueOf(acc[0].Id).subString(0,15);
                System.debug('***\n subStr = ' + subStr + '\n');
                RealTimeCustomerURL__c realTimeUrl = RealTimeCustomerURL__c.getInstance();
                String endpoint = realTimeUrl.Real_Time_URL__c;
                String reqBody = '{"SalesforceId": "' + acc[0].Id + 
                                 '","FirstName" : "' + acc[0].FirstName + 
                                 '","LastName": "' + acc[0].LastName + 
                                 '","ClassCode": "' + CLASS_CODE + 
                                 '","UserName":"' + myOracleUserName + 
                                 '","PartyType":"' + PARTY_TYPE + '"}';
                System.debug('***\n endpoint = ' + endpoint + '\n');
                System.debug('***\n reqBody = ' + reqBody + '\n');
                map<string,string> cResults =  RealTimeCustomerServiceCall.getCalloutResponseContents(endpoint, reqBody);
                System.debug('***\n cResults = ' + cResults + '\n');
                
                if(cResults != null){
                    if(cResults.Containskey('AccountNumber')){
                        accountNumber =  cResults.get('AccountNumber');
                    }
                    
                    if(cResults.Containskey('PartyId')){
                        partyId =  cResults.get('PartyId');
                    }
                    
                    System.debug('***\n accountNumber = ' + accountNumber + '\n');
                    System.debug('***\n partyId = ' + partyId + '\n');
                    if(cResults.containsKey('STATUS')){
                        result = cResults.get('STATUS');
                    }else if(cResults.containsKey('ResponseCode')){
                    	if(String.valueOf(cResults.get('ResponseCode')) == '1'){
                    		result = 'SUCCESS';
                    		acc[0].AccountNumber = accountNumber;
                    		acc[0].Party_ID__c = partyId;
                    		
                     		update acc;
                    	}else{
                    		result =  'Error calling web service: ' + (cResults.get('Message') == null ? '' : cResults.get('Message'));
                    	}
                        
                    }
                }else{
                	result = 'Result returned from real time web service was empty';
                }
                
            }else{
                result = 'Either FirstName or LastName or Oracle UserName is blank.';
            }
            }else{
            	result = 'This account is already created in Oracle';
            }
            
        }catch(Exception ex){
            result = 'Exception error: ' + ex.getMessage();
        }
        if(result == ''){
            result = 'Exception error 2 - Result is empty';
        }
        
        return result;
    }
}