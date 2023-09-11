/**
 * @description       : 
 * @author            : Tushar Kumar
 * @group             : 
 * @last modified on  : 09-11-2023
 * @last modified by  : Tushar Kumar
**/
public class AccountTriggerHandler {
    // Method To Create Task Record
    public static void createTaskOnAccount(List<Account> newAccountList){
        List<Task> taskToInsertList = new List<Task>();
        
        for (Account acc : newAccountList) {
            Task newTaskRecord = new Task();
            newTaskRecord.WhatId = acc.Id;
            newTaskRecord.OwnerId = acc.OwnerId;
            newTaskRecord.Subject = 'Review Account- ' + acc.AccountNumber;
            newTaskRecord.ActivityDate = System.today().addDays(7);
            newTaskRecord.Status = 'Not Started';
            taskToInsertList.add(newTaskRecord);
        }
        
        if (!taskToInsertList.isEmpty()) {
            insert taskToInsertList;
        }
    }

    // Method To Update Task Related To Account
    public static void updateTaskRelatedToActiveAccount(List<Account> newAccountList,Map<Id, Account> oldAccountMap){
        Set<Id> setOfActiveAccountId = new Set<Id>();
        Id userId = UserInfo.getUserId();
        for(Account accRecord : newAccountList){
            if(oldAccountMap!=NULL && oldAccountMap.get(accRecord.Id).Active__c!=true && accRecord.Active__c == true ){
                setOfActiveAccountId.add(accRecord.Id);
            }
        }
        
        if(!setOfActiveAccountId.isEmpty()){
            List<Task> taskToUpdateList = new List<Task>();
            for (Task taskRecord : [Select Id,Status,Description,WhatId FROM Task WHERE WhatId IN: setOfActiveAccountId]) {
               if(taskRecord.Status!='Completed'){
                taskRecord.Status = 'Completed';
                taskToUpdateList.add(taskRecord);
               }
            }
            if (!taskToUpdateList.isEmpty() && TaskTriggerHandler.checkPermissionSet(userId)) {
                update taskToUpdateList;
            }
            
        }
    }

}