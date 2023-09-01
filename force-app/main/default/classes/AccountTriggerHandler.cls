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
}