public class PCSCallList {
/********************************************************************************
@author Abhishek Parghi
@Createddate 10/08/2015
@description: To populate Return Call List and Initial Call List on accounts.
*******************************************************************************
    /*PCS notes Return list */
    Public Static void DxReturnCallList(List<Dx_notes__c> ListDx){
        for(Dx_notes__c Dx: ListDx){
            IF(ListDx.size() > 0){
                 If(Dx.Interaction_Status__c !='Completed - no follow up'){
                    Dx.Return_Call_List__c = true; 
                 }else{
                    Dx.Return_Call_List__c = false;   
                }
           }
    }
    }  
    /*PCS notes Return list*/
   Public Static void AccountReturnCallList(List<Dx_notes__c> ListDx2){
        Map<ID, Account> Accs = new Map<ID, Account>();
        List<Id> listIds = new List<Id>();
      
        for(Dx_notes__c Dxc : ListDx2){
            listIds.add(Dxc.CONSUMER__c);
        }
        Accs = new Map<Id, Account>([SELECT id, ReturnCall_List__c,(select id, Return_Call_List__c, Interaction_Status__c,Follow_Up_Day__c,CreatedDate from Dx_notes__r) FROM Account WHERE ID IN :listIds]);
          for (Dx_notes__c Dxx: ListDx2){
             Account Act = Accs.get(Dxx.CONSUMER__c);
                if(Dxx.Interaction_Status__c != null){ 
                      if((Dxx.Interaction_Status__c == 'Follow up in 7')
                       ||(Dxx.Interaction_Status__c == 'Follow up in 14')
                       ||(Dxx.Interaction_Status__c == 'Follow up in 30')
                       ||(Dxx.Interaction_Status__c == 'Follow up in 60')
                       ||(Dxx.Interaction_Status__c == 'Follow up in 90')
                       ||(Dxx.Interaction_Status__c == 'Completed - no follow up')){
  
                            Act.ReturnCall_List__c = Dxx.Return_Call_List__c;
                            Act.Initial_call__c = false;
                            Act.Initial_CallList_Follow_up_Date__c = null;
                            Act.Patient_Care_Follow_up__c =  Dxx.Interaction_Status__c;
                            Act.Latest_Interaction_Date__c = Dxx.CreatedDate ;
                            Act.Return_list_follow_up_date__c  = Dxx.Follow_Up_Day__c  ;
                            Act.Has_PCS_Notes__c = true;
                      }else{    
                            Act.PCS_Additional_Information__c =  Dxx.Interaction_Status__c;
                     }
                    }    
          }    
            
        update Accs.values();
    }
    /*Order item Detail AccountID Update*/
    Public Static void OIDAccountIdUpdate(List<Order_Item_Detail__c> ListOID2){ 
     	set<string> Zipcodes = new set<string>();  
     	set<ID> listIds = new Set<ID>(); 
      
      	for(Order_Item_Detail__c OL : ListOID2){
            listIds.add(OL.Order_Header__c);
        }
        
   		map<ID,string> OHeaderMAp	=new map<ID,string>();  
   		for(Order_Header__c	z : [Select ID,Account__c  from Order_Header__c WHERE Order_Type__c != 'Tech Replacement Order' AND ID	IN :listIds]) 	{
         	OHeaderMAp.put (z.ID, z.Account__c);
        }
   		for(Order_Item_Detail__c OL2 : ListOID2){
      		if(OL2.Shipping_Date__c != null){
       		   ID acc = OHeaderMAp.get(OL2.Order_Header__c); 
          	   OL2.ACC_ID__c = acc;
            }
        }       
    }
    /*Initial CallList*/
	Public Static void OIDInitialCallList(List<Order_Item_Detail__c> ListOID){ 
       	 Map<ID, Account> Accts = new Map<ID, Account>();
         Set<Id> listIds = new Set<Id>();
         System.debug('##AP ' + ListOID.size() + ' ##');
         for(Order_Item_Detail__c OLD : ListOID){
                listIds.add(OLD.ACC_ID__c);
         }
         System.debug('##OLD ' + listIds.size() + ' ##');  
    
         if(listIds.size()>0){
           Accts = new Map<Id, Account>([SELECT id,Initial_call__c, ReturnCall_List__c,Has_PCS_Notes__c  FROM Account WHERE Has_PCS_Notes__c = false AND ID IN :listIds]);
            if(Accts.size()> 0){
               for(Order_Item_Detail__c OLID : ListOID){
                   Account ParentAcc = Accts.get(OLID.ACC_ID__c );
                   IF(ParentAcc != Null){
                      System.debug('has PCS note false');
					  ParentAcc.Initial_call__c  = OLID.Initial__c;  
                      ParentAcc.Initial_List_FollowUp_Date__c = OLID.Initial_CallList_Follow_up_Date__c;   
                   }
               } 
            }   
          update Accts.values();   
       }
        
    } 
}