/**
 * AUTHOR       : SHERLYN GARCIA(CLOUD SHERPAS)
 * DESCRIPTION  : TEST CLASS FOR FORMTEXT TRIGGER
 * HISTORY      : 22.MAR.2016 SGARCIA - Created.
 */
@isTest
public class FormTextTriggerHandler_Test {
	/**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : TEST DATA SETUP METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 22.MAR.2016 SGARCIA - Created.
    */
    @testSetup static void setup() {
    	FormText__c formText = new FormText__c();
    	formText.Name = 'Test Name';
    	formText.Contact_Details__c = 'For tech Support issues, please call 1-888-738-3646.';
    	formText.Terms_And_Conditions__c = 'This chat service is provided by Dexcom, Inc. (Dexcom) for customer support in using the Dexcom website, submitting information to Dexcom regarding my account, and providing general information regarding Dexcom products and is subject to the Dexcom <a href="http://www.dexcom.com/linked/documentservice/TermsOfUse" target="_blank">terms of use</a> and <a href="http://www.dexcom.com/linked/documentservice/PrivacyPolicy" target="_blank">privacy policy</a>.  I understand that this chat service is not medical or health care services, and if I have any medical or health concerns, I will contact my physician or other health care provider, and if I need emergency assistance, I need to dial 911 on my phone. I also understand that Dexcom uses a sneak-peak process so that it can view my chat message as I am typing it to facilitate its responses to my chat message.<br/>';
    	insert formText;
    }

    /**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : UNIT TEST METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 22.MAR.2016 SGARCIA - Created.
    */
    @isTest static void myUnitTest() {
    	Test.startTest();
    		FormText__c formText = new FormText__c();
	    	formText.Name = 'Test Name2';
	    	formText.Contact_Details__c = 'For tech Support issues, please call 1-888-738-3646.';
	    	formText.Terms_And_Conditions__c = 'This chat service is provided by Dexcom, Inc. (Dexcom) for customer support in using the Dexcom website, submitting information to Dexcom regarding my account, and providing general information regarding Dexcom products and is subject to the Dexcom <a href="http://www.dexcom.com/linked/documentservice/TermsOfUse" target="_blank">terms of use</a> and <a href="http://www.dexcom.com/linked/documentservice/PrivacyPolicy" target="_blank">privacy policy</a>.  I understand that this chat service is not medical or health care services, and if I have any medical or health concerns, I will contact my physician or other health care provider, and if I need emergency assistance, I need to dial 911 on my phone. I also understand that Dexcom uses a sneak-peak process so that it can view my chat message as I am typing it to facilitate its responses to my chat message.<br/>';
	    	try {
	    		insert formText;
	    	} catch(DmlException dmle) {
	    		System.debug('Error' + dmle);
	    	}
    	Test.stopTest();
    }
}