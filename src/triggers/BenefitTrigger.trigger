trigger BenefitTrigger on Benefits__c (before insert, after update, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            BenefitTriggerHandler.beforeInsert(trigger.new);
            BenefitTriggerHandler.DX_DSC_Insur_Info(trigger.new);
        }
        
        if(trigger.isUpdate){
            BenefitTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
            BenefitTriggerHandler.DX_DSC_Insur_Info(trigger.new);
        }
    }
    if(trigger.isAfter){
      if(trigger.isUpdate){
            BenefitTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
        }  
    }
}