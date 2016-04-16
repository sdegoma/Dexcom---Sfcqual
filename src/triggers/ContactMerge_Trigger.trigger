/********************************************************************************
@author Abhishek Parghi
@date 07/20/2015
@description: This trigger merges any two contacts. Contact Merge object can be populated manually
or programatically. The Name field is the master account and the Contact_Merge field is the contact
that will merge into the master contact and then will be deleted. Please select batch size 1 when you 
load contact merge records through API.
********************************************************************************/
trigger ContactMerge_Trigger on Contact_Merge__c (after insert) {
  Set<String> Contactmergenames = new Set<String>();
  Set<Id> ContactmergeloseIds = new Set<Id>(); 
  List<String> CntID = new List<String> ();

     try{
       /*This queries all new contact merge record ids.*/
       List<Contact_Merge__c> ContactmergeIds = [SELECT id, name, Contact_Merge__c  FROM Contact_Merge__c WHERE ID IN :Trigger.newMap.keySet()];    
      
       for(Contact_Merge__c c: ContactmergeIds){
         if(c.name != null){
            Contactmergenames.add(c.name); 
            ContactmergeloseIds.add(c.Contact_Merge__c);    
         }else{
            System.debug('Contact name is blank');  
          }
       }
       /*This Queries master and loser record to perform a single merge DML statement*/
       Account masterAccount = [SELECT id, Dexcom_Rating__pc, Call_Goal__pc    FROM Account WHERE party_id__c IN :Contactmergenames LIMIT 1];
       Account LoseAccount = [SELECT id, Dexcom_Rating__pc,Call_Goal__pc FROM Account WHERE Id IN :ContactmergeloseIds LIMIT 1];
       
         /*update dexcom rating and call goal fields on master contact record*/
         if((String.isBlank(masterAccount.Dexcom_Rating__pc) && (!String.isBlank(LoseAccount.Dexcom_Rating__pc)))) {
            masterAccount.Dexcom_Rating__pc = LoseAccount.Dexcom_Rating__pc;
            masterAccount.Call_Goal__pc= LoseAccount.Call_Goal__pc;
         }else if((masterAccount.Dexcom_Rating__pc != LoseAccount.Dexcom_Rating__pc) &&(!String.isBlank(masterAccount.Dexcom_Rating__pc)) && (!String.isBlank(LoseAccount.Dexcom_Rating__pc))&&(masterAccount.Dexcom_Rating__pc.Substring(0,1) > LoseAccount.Dexcom_Rating__pc.Substring(0,1))) {
            masterAccount.Dexcom_Rating__pc = LoseAccount.Dexcom_Rating__pc; 
            masterAccount.Call_Goal__pc= LoseAccount.Call_Goal__pc;
         }else{
            System.debug('Dexcom rating is blank'); 
         }    
         update masterAccount; 
         merge masterAccount LoseAccount;
     }catch(exception e) {
             System.debug('Contact merge failed: ' + e.getMessage());
      }
}