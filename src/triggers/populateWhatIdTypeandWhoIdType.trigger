trigger populateWhatIdTypeandWhoIdType on Task (before insert, before update) {
/*
   //look at the database.
   Schema.SObjectType result;
   map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

   // map all key prefixes to object type labels.

   String prefix;
   map<String, String> prefixMap = new map<String, String>();
   for (Schema.SObjectType ot : gd.values())
   {
      prefix = ot.getDescribe().getKeyPrefix();
      if (prefix != null)
      {
       prefixMap.put(prefix, ot.getDescribe().getLabel());
      }
   }

   // Loop through all Tasks in this transaction.
   String sub1;
   String lbl1;
   // Loop through all Tasks in this transaction.
   String sub='';
   String lbl;
   String pac;
   String twhoIDtype;
   pac = '003';
   String CDE = 'a04';
   String WhatIDVar='';

  
   
Map<Id,SObject>  persontaskMap = new Map<Id,SObject>();
List<Task> taskwhotype = new list<Task>(); 
List<Task> updatepersonTask = new list<Task>();

//Here we need to fill the persontaskmap before we Query the personacList :: Venkat Kollimarla

for (Task t: system.trigger.new)
{
      // You can actually have a Task without a Related To value.  
      if (t.WhoId != null && t.WhatId == null)
      {
            // Get the first three characters from the Who ID.
            sub = String.valueOf(t.WhoId).substring(0, 3);
            if (sub != null)
            {
                        if (sub.contains(pac))
                                    { 
                                        //is contact or person account, put id in map to check IsPersonAccount__c in Account
                                        persontaskMap.put(t.whoid, t);
                                    }
            }
       }
}
                                  
//End of filling persontaskMap

list<Contact> personaclist = new list<Contact>(); // this list is person accounts
personacList = ([SELECT Id from Contact Where ((Id IN: persontaskmap.keyset()) AND Account.IsPersonAccount != FALSE)]);   // Brought out of loop


for (Task t: system.trigger.new)
{
      // You can actually have a Task without a Related To value.  
      if (t.WhoId != null && t.WhatId == null)
      {
            // Get the first three characters from the Who ID.
            sub = String.valueOf(t.WhoId).substring(0, 3);
  
      
          
        if (sub != null)
        {
            /*****************
                            if (sub.contains(pac)){ 
                                        //is contact or person account, put id in map to check IsPersonAccount__c in Account
                                        persontaskMap.put(t.whoid, t);
                                  } ******************************************/
   /*
                if (persontaskMap.containskey(t.whoid))
                    {
                                    system.debug('%%%%%%%');
                                    // its either a contact or person account (if account.IsPersonAccount__c = TRUE 
                                    //Code removed from HERE for 
   
   
                                    Map<Id,Contact> taskpersonMap = new Map<Id,Contact>(personaclist);
   
                                    if(taskpersonMap.containskey(t.whoid))
                                        { //persontaskmap said is contact, taskpersonmap says is contact belonging to person account
                                                t.WhoIDType__c = 'Person Account';
                                        }
                                    else
                                        {
                                                t.WhoIDType__c = 'Contact';
                                        }
      
                    }       
    
        }
    }
  else if(t.WhatId != NULL){
          system.debug('@@@@@@@@@@'+t.WhatId);
         WhatIDVar = String.valueOf(t.WhatId).substring(0, 3);
         system.debug('#####'+WhatIDVar);
          system.debug('WhatId@@@@@@');
  
  sub1 = String.valueOf(t.WhatId).substring(0, 3);
        if (sub1 != null)
        { 
            // Look up the prefix in the map.
         lbl1 = prefixMap.get(sub1);
         if (lbl1 != null)
         {
            // Save it in the object for reporting.
            t.WhatIDType__c = lbl1;
         }
        }
 
  if(String.valueOf(t.WhatId).substring(0, 3) == CDE)
        {
             system.debug('$$$$$$$$'+t.WhoIDType__c);
             t.WhoIDType__c = '';

        } 
  }
 
 }   // For-Loop End;
*/
}