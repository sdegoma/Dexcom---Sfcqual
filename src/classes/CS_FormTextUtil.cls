/**
 * AUTHOR       : Sherlyn Garcia(Cloud Sherpas)
 * DESCRIPTION  : Retrieve Terms and conditions, techsupport contact
 * HISTORY      : 22.MAR.2016 SGarcia- Created.
 */
public class CS_FormTextUtil {
    public FormText__c formTextObj {get; set;}
    public CS_FormTextUtil() {
        formTextObj = new FormText__c();
        formTextObj = [SELECT Id, Contact_Details__c, Terms_And_Conditions__c FROM FormText__c LIMIT 1];
    }

    public CS_FormTextUtil(ApexPages.StandardController stdController) {
        formTextObj = new FormText__c();
        formTextObj = [SELECT Id, Contact_Details__c, Terms_And_Conditions__c FROM FormText__c LIMIT 1];
    }
}