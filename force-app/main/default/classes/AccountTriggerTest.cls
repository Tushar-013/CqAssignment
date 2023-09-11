/**
 * @description       : 
 * @author            : Tushar Kumar
 * @group             : 
 * @last modified on  : 09-11-2023
 * @last modified by  : Tushar Kumar
**/
@isTest
public class AccountTriggerTest {
    
    // Create Test Data 
    @testsetup static void setup()
    {
        Account acc = new Account(Name = 'Test Account', Active__c = false);
        insert acc;
    }
    
    // Method To test account creation with Inactive (Active = unchecked)
    @isTest
    static void testAccountCreation() {
        Account acc = [SELECT Id,AccountNumber,OwnerId FROM Account WHERE Name = 'Test Account'];
        // Retrieve the inserted account and verify its Active status
        Account insertedAccount = [SELECT Id,Active__c,AccountNumber,OwnerId FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.assertEquals(false, insertedAccount.Active__c);
        List<Task> tasks = [SELECT Subject, ActivityDate, OwnerId, Status,WhatId FROM Task WHERE WhatId = :insertedAccount.Id];
        System.assertEquals(1, tasks.size());
        Task createdTask = tasks[0];
        System.assertEquals('Review Account- '+ acc.AccountNumber,createdTask.Subject);
        System.assertEquals(System.today().addDays(7), createdTask.ActivityDate);
        System.assertEquals(acc.Id, createdTask.WhatId);
        System.assertEquals(acc.OwnerId, createdTask.OwnerId);
        System.assertEquals('Not Started', createdTask.Status);

    }
    
    @isTest
    static void testTaskRelatedToActiveAccount() {
        Account acc = [SELECT Id,Active__c,AccountNumber,OwnerId FROM Account WHERE Name = 'Test Account'];
        System.assertEquals(false, acc.Active__c);
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
        User u = new User(firstname= 'Test User',
  						  lastname='123',
  						  Alias='t123',
  						  email = 'test.1234@yopmail.com',
  						  username= 'test.1234@yopmail.com.dev', 
  						  profileId= p.id, 
  						  emailencodingkey='UTF-8',
  						  languagelocalekey='en_US',
  						  localesidkey='en_US',
  						  timezonesidkey='America/Los_Angeles');
  		insert u;
        System.runAs(u){
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin'];
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
           	Account updatedAcc = [SELECT Id FROM Account WHERE Id = :acc.Id LIMIT 1];
            updatedAcc.Active__C = true;
            update updatedAcc;
            System.assertEquals(true, updatedAcc.Active__C);
            Task task = [SELECT Id,Subject,WhatId,OwnerId,Status,ActivityDate FROM Task WHERE WhatId = :acc.Id LIMIT 1];
            System.assertEquals('Review Account- '+ acc.AccountNumber,task.Subject);
            System.assertEquals(System.today().addDays(7), task.ActivityDate);
            System.assertEquals(acc.Id, task.WhatId);
            System.assertEquals(acc.OwnerId, task.OwnerId);
            System.assertEquals('Completed', task.Status);
        }
    }
}