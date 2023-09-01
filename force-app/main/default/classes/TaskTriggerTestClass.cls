@isTest
public class TaskTriggerTestClass {
    
    // Create Test Data 
    @testsetup static void setup()
    {
        Account acc = new Account(Name = 'Test Account',AccountNumber = '001', Active__c = false);
        insert acc;
    }
    
    // Method To test task is created with the correct details
    @isTest
    static void testTaskCreation() {
        Account acc = [SELECT Id,AccountNumber,OwnerId FROM Account WHERE Name = 'Test Account'];
        List<Task> tasks = [SELECT Subject, ActivityDate, OwnerId, Status,WhatId FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(1, tasks.size());
        Task createdTask = tasks[0];
        System.assertEquals('Review Account- '+ acc.AccountNumber,createdTask.Subject);
        System.assertEquals(System.today().addDays(7), createdTask.ActivityDate);
        System.assertEquals(acc.Id, createdTask.WhatId);
        System.assertEquals(acc.OwnerId, createdTask.OwnerId);
        System.assertEquals('Not Started', createdTask.Status);
    }
    
    // Method To test task is created with the correct details
    @isTest
    static void testTaskCompletion() {
        Account acc = new Account(Name = 'Test Account',AccountNumber = '002', Active__c = false);
        insert acc;        
        User user = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        System.runAs(user){
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin'];
            insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);
            
            Task task = [SELECT Id FROM Task WHERE WhatId = :acc.Id LIMIT 1];
            task.Status = 'Completed';
            task.OwnerId = user.Id;
            task.Description = 'This is a test comment.';
            update task;
           // system.assert(false,task);
        }
   
        
        Account activatedAccount = [SELECT Active__c,Description FROM Account WHERE Id = :acc.Id AND AccountNumber = '002'LIMIT 1];
        System.assertEquals(true, activatedAccount.Active__c);
        System.assertEquals('This is a test comment.', activatedAccount.Description);
        
    }
    
    // Method To test task is created with the correct details and from Standard User
    @isTest
    static void testTaskCompletionFromStandardUser() {
        Account acc = new Account(Name = 'Test Account',AccountNumber = '003', Active__c = false);
        insert acc;        
        User user = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        System.runAs(user){
            Task task = [SELECT Id FROM Task WHERE WhatId = :acc.Id LIMIT 1];
            task.Status = 'Completed';
            task.OwnerId = user.Id;
            task.Description = 'This is a test comment.';
            update task;
        }
   
        
        Account activatedAccount = [SELECT Active__c,Description FROM Account WHERE Id = :acc.Id AND AccountNumber = '003'LIMIT 1];
        System.assertEquals(false, activatedAccount.Active__c);      
    }
    
    
}