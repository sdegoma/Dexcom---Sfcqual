/**********************************************************
 **Description: Account trigger handler Class. All the CRUD events are handled here.
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JULY.14.2015
**********************************************************/
public class AccountTriggerHandler {
    public static void onBeforeInsert(List<Account> listAccount){
        copyEmail(listAccount);
    }
    
    /********************************************************************************
     * revision     : Kingsley Tumaneng NOV 3, 2015 - Added a validation if fields
                      are changed, it will update the Integration Last Modified Date
    *********************************************************************************/
    public static void onBeforeUpdate(List<Account> listAccount, Map<Id, Account> oldMap){
        List<Account> toBeUpdated = new List<Account>();
        
        Id RecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        
        for(Account acc : listAccount){
            system.debug('***acc.RecordTypeId = ' + acc.RecordTypeId);
            system.debug('***RecTypeId = ' + RecTypeId);
            if(acc.RecordTypeId == RecTypeId){
                if(acc.Name != oldMap.get(acc.Id).Name || 
                    acc.Gender__c != oldMap.get(acc.Id).Gender__c || 
                     acc.DOB__c != oldMap.get(acc.Id).DOB__c ||  
                      acc.Payor__c != oldMap.get(acc.Id).Payor__c ||  
                       acc.PersonMobilePhone != oldMap.get(acc.Id).PersonMobilePhone ||  
                        acc.PersonHomePhone != oldMap.get(acc.Id).PersonHomePhone || 
                         acc.PersonOtherPhone != oldMap.get(acc.Id).PersonOtherPhone ||
                          acc.PersonEmail != oldMap.get(acc.Id).PersonEmail ||
                           acc.Medical_Facility__c != oldMap.get(acc.Id).Medical_Facility__c ||
                            acc.Prescribers__c != oldMap.get(acc.Id).Prescribers__c ||
                             acc.Diagnosis_Code_1_Acc__c != oldMap.get(acc.Id).Diagnosis_Code_1_Acc__c ||
                              acc.Diagnosis_Code_2_Acc__c != oldMap.get(acc.Id).Diagnosis_Code_2_Acc__c ||
                               acc.CMN_or_Rx_Expiration_Date__c != oldMap.get(acc.Id).CMN_or_Rx_Expiration_Date__c ||
                                acc.Inactive__c != oldMap.get(acc.Id).Inactive__c ||
                                 acc.Default_Price_Book__c != oldMap.get(acc.Id).Default_Price_Book__c) {
                    
                            acc.Integration_Last_Modified_Date__c = dateTime.now();
                            toBeUpdated.add(acc);
                }
            }
        }
        
        copyEmail(listAccount);
    }
    /**********************************************************
     **Description: Copys the person email to the custom person email field
     **Parameters:  List<Account> listAccount
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JULY.14.2015
    **********************************************************/
    public static void copyEmail(List<Account> listAccount){
        for(Account a:listAccount){
            a.Personemail__c = a.PersonEmail;
        }
    }
    
    
  
}