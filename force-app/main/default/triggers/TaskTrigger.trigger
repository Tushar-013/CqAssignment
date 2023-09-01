trigger TaskTrigger on Task (before insert, after insert, before update, after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        TaskTriggerHandler.activateAndSetDescriptionAccount(Trigger.new,Trigger.oldMap);
    }

}