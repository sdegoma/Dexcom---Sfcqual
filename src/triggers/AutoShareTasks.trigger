trigger AutoShareTasks on Task (after insert, after update)
{

String temp;
Opportunity op;
Map<ID,LIST<Task>> oppIdToTasks = new Map<ID,LIST<Task>>();
Map<ID,Opportunity> oppIdToOpp = new Map<ID,Opportunity>();
String oppcode = '006';
String sub = '';

List<ID> opportunityIds = new List<ID>();

    for(task t : trigger.new)
    {
        if (t.WhatId != null)
      {
         sub = String.valueOf(t.WhatId).substring(0,3);
            if (sub != null)
            {
                if (sub.contains(oppcode))
                         opportunityIds.add(t.WhatId);
            }
         }
    }
if(opportunityIds.size()>0)
{

    for(opportunity o :[SELECT id,Dist_Activity_Notes__c FROM opportunity WHERE id IN :opportunityIds LIMIT 49999])
    {
        oppIdToOpp.put(o.id, o); 
    }

    for(Task t :[SELECT id,subject,WhatId,createdDate,Distributor_To_See__c FROM Task WHERE WhatId IN :opportunityIds AND Distributor_To_See__c = 'DSC' LIMIT 49999])
    {
        If(oppIdToTasks.ContainsKey(t.WhatId))
        {
                oppIdToTasks.get(t.WhatId).add(t);
        }
        else
         {
                List<Task> tempList = new List<Task>();
                tempList.add(t);
                oppIdToTasks.put(t.WhatId,tempList);           
        }
    
    }

}

if(oppIdToTasks.size()>0)
{
    for(ID oppId : oppIdToTasks.keySet())
        {
    //Opportunity o = oppIdToOpp.get(oppId);
    op = oppIdToOpp.get(oppId);
    temp = ''; 
       
        for(Task t : oppIdToTasks.get(oppId))
        {
            //if(t.Distributor_To_See__c == 'DSC')  //Check if allowed to share to DSC and then gather all the tasks info together;
            //{
               temp += t.subject + ' : ' + t.createddate + '\n';
               
            //}
        }
    if(temp!=null)
        { op.Dist_Activity_Notes__c = temp; }
    
    oppIdToOpp.put(oppId,op);

    }
}

    try{ 

        if(oppIdToOpp.size()>0)
                update oppIdToOpp.values(); 
        }
catch(Exception e) { System.debug('AutoShareTasks Exception' + e.getMessage()); }
    
}