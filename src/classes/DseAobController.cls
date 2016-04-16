public with sharing class DseAobController {
	
  //public static String DST_TEMPLATE_ID = 'FD66512A-F07C-4CFA-8D5A-8F1F27157863'; //Demo
    public static String DST_TEMPLATE_ID = '43B8FB34-8549-4CC3-A2E3-C77CEE2F40A7'; //Production
	public static String DS_INTEGRATOR_KEY = 'DEXC-4fa57d47-3291-49af-88a5-9a11ab3f9523';
	public static String DS_ENVELOPE_STATUS = 'sent';
		
	public DseAobController(){
	}

    public DseAobController(ApexPages.StandardController controller){
    } 
    
    /**
    * Create an envelope base on template DST_TEMPLATE_ID on a given opportunity.
    */
    @future (callout=true)
    public static void createEnvelopeFromOpportunity(string oppId) {
    	try{
    		//Retrieve the Opportunity data
	    	Opportunity opportunity = DseAobHelper.getOpportunity(oppId);
	    	System.debug(opportunity);
	    	if (opportunity != null){
		    	//Retrieve the SA User defined on the opportunity
		    	User user = DseAobHelper.getUserByTerritoryId(opportunity.Territory_Name__c);
		    	System.debug(user);
		    	
		    	System.debug(DseAobHelper.CreateDocuSignAuthentication(user.Email, DS_INTEGRATOR_KEY));
		    	System.debug('****opportunity patient email:' + opportunity.Patient_Email__c);
		    	
		    	//Retrieve the SA User defined on the opportunity
		    	Account account = DseAobHelper.getAccountByOpportunityId(oppId);
		    	System.debug(account);
		    	
		    	//If the patient email is not there then we throw a DseOpportunityException
		    	if(DseStringUtils.isNullOrEmpty(account.PersonEmail)){
		    		throw new DseOpportunityException('Account PersonEmail was null in account ' + account);
		    	}
		    	if (account != null){
			    	
			    	String emailSubject = '"Dexcom Document AOB - Signature Needed for ' +  opportunity.Patient_First_Name__c + 
			    		' ' + opportunity.Patient_Last_Name__c + '"';
			    	
			    	String payLoad = '{"emailSubject": ' + emailSubject + ',"templateId": "' + DST_TEMPLATE_ID + '",' +
			    		'"templateRoles": [{"name": ' + '"' + opportunity.Patient_First_Name__c + ' ' + opportunity.Patient_Last_Name__c + '"' +
			    		',"email": ' + '"' + account.PersonEmail + '"' + ',"roleName":"Patient",' + 
			    		'"tabs":{"textTabs":[{"tabLabel":"Account Name","value":"' + account.Name +'"},';
			    		
					if (account.BillingAddress != null || DseStringUtils.isNotNullOrEmpty(account.BillingAddress.getStreet())){
		    			payLoad += '{"tabLabel":"Street Adress","value":"' + account.BillingAddress.getStreet() +'"},';
		    		}
			    		 
		    		payLoad += '{"tabLabel":"Billing City","value":"' + account.BillingCity +'"},' +
		    			'{"tabLabel":"Billing State","value":"' + account.BillingState +'"},' +
		    			'{"tabLabel":"Billing ZIP","value":"' + account.BillingPostalCode +'"},' +
		         		'{"tabLabel":"Phone","value":"' + account.PersonHomePhone +'"}]' +
		          		'}}],"status": "' + DS_ENVELOPE_STATUS + '",' +
		          		'"customFields":{"textCustomFields":[{"name":"DSFSSourceObjectId","required":"false","show":"false",' + 
						'"value":"' + opportunity.ID_Lookup__c + '~Opportunity"},' + 
						'{"name":"##SFOpportunity","required":"false","show":"false","value":"' + opportunity.ID_Lookup__c + '"},' + 
						'{"name":"##SFAccount","required":"false","show":"false","value":"' + account.Id + '"}]}}'; 
			    	
			    	System.debug(payLoad);
			    	System.debug(DseAobHelper.getDsAccountConfiguration());
			    	
			    	//Here we setup the HTTP Request
			    	HttpRequest request = new HttpRequest();
					request.setEndpoint(DseAobHelper.getDsAccountConfiguration().dsfs__DocuSignBaseURL__c + 'restapi/v2/accounts/' + 
						DseAobHelper.getDsAccountConfiguration().dsfs__AccountId__c  + '/envelopes');
					request.setMethod('POST');
					request.setHeader('Content-Type', 'application/json');
					request.setHeader('X-DocuSign-Authentication', DseAobHelper.CreateDocuSignAuthentication(user.Email, DS_INTEGRATOR_KEY));
					request.setHeader('Accept', 'application/json');
					request.setTimeout(120000);
					request.setBody(payLoad);
					// Now let's execute the HTTP Request
					HttpResponse myResponse = (new Http()).send(request);
		
					system.debug('Status for the Create Envelope was ' + myResponse.getStatusCode());
					
					if(myResponse.getStatusCode().format()=='201')
					{  
						system.debug(myResponse.getBody());
					}
		    	} else {
		    		throw new DseOpportunityException('Account criteria not meet' +  'probably record type name is not "Consumers"');
		    	}
	    	} else {
	    		throw new DseOpportunityException('Opportunity criteria no meet, either StageName is not "1. New Opportunity" ' +
		    		'or Status is not "1.2 Online Opportunity" or opportunity is closed');
	    	}
    	} catch (Exception e){
    		System.debug(e);
    	}
    	finally{
    		
    	}
    	
    }
    
    

}