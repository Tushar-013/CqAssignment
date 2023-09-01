trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.createTaskOnAccount(Trigger.new);
    }
}