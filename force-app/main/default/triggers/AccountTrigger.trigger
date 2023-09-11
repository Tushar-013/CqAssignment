trigger AccountTrigger on Account (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.createTaskOnAccount(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.updateTaskRelatedToActiveAccount(Trigger.new,Trigger.oldMap);
    }
}