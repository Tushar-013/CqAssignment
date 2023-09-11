public class TaskTriggerHandler {
    // Method To Activate and Transfer Account Description After Task is Completed Record
    public static void activateAndSetDescriptionAccount(List<Task> newTaskList,Map<Id, Task> oldTaskMap){
        List<Task> tasksToInsertList = new List<Task>();
        Set<Id> setOfCompletedTaskId = new Set<Id>();
        Id userId = UserInfo.getUserId();
        if(checkPermissionSet(userId)){
            for(Task taskRecord : newTaskList){
                if(oldTaskMap!=NULL && oldTaskMap.get(taskRecord.Id).Status!=taskRecord.Status && taskRecord.Status == 'Completed' ){
                    setOfCompletedTaskId.add(taskRecord.Id);
                }
            }
        }
                
        if(!setOfCompletedTaskId.isEmpty()){
            List<Account> accountToUpdateList = new List<Account>();
            for (Task taskRecord : [Select Id,Status,Description,WhatId FROM Task WHERE ID IN: setOfCompletedTaskId]) {
                Account acc = [SELECT Id 
                               FROM Account 
                               WHERE Id =: taskRecord.WhatId];
                acc.Active__c = true;
                acc.Description = taskRecord.Description;
                accountToUpdateList.add(acc);
            }
            if (!accountToUpdateList.isEmpty()) {
                update accountToUpdateList;
            }
            
        }
    }
        
    // Method To Check User Permission Set
    public static Boolean checkPermissionSet(Id userId){
        List<PermissionSetAssignment> permissionSetList = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name 
                                                           FROM PermissionSetAssignment 
                                                           WHERE PermissionSet.Name = 'CQ_Account_Admin'
                                                           AND AssigneeId =:userId];
        if(!permissionSetList.isEmpty()){
            return true;
        }
        return false; 
    }
}