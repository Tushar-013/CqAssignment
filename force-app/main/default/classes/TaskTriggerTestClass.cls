/**
 * @description       : 
 * @author            : Tushar Kumar
 * @group             : 
 * @last modified on  : 09-11-2023
 * @last modified by  : Tushar Kumar
**/
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
            
            Task task = [SELECT Id FROM Task WHERE WhatId = :acc.Id LIMIT 1];
            task.Status = 'Completed';
            task.OwnerId = u.Id;
            task.Description = 'This is a test comment.';
            update task;
        }
   
        
        Account activatedAccount = [SELECT Active__c,Description FROM Account WHERE Id = :acc.Id AND AccountNumber = '002' LIMIT 1];
        System.assertEquals(true, activatedAccount.Active__c);
        System.assertEquals('This is a test comment.', activatedAccount.Description);
        
    }
    
    // Method To test task is created with the correct details and from Standard User
    @isTest
    static void testTaskCompletionFromWithOutPermission() {
        Account acc = new Account(Name = 'Test Account',AccountNumber = '003', Active__c = false);
        insert acc;        
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
        User u = new User(firstname= 'Test User1',
  						  lastname='1231',
  						  Alias='t1231',
  						  email = 'test.12341@yopmail.com',
  						  username= 'test.12341@yopmail.com.dev', 
  						  profileId= p.id, 
  						  emailencodingkey='UTF-8',
  						  languagelocalekey='en_US',
  						  localesidkey='en_US',
  						  timezonesidkey='America/Los_Angeles');
  		insert u;	
        System.runAs(u){
            Task task = [SELECT Id FROM Task WHERE WhatId = :acc.Id LIMIT 1];
            task.Status = 'Completed';
            task.OwnerId = u.Id;
            task.Description = 'This is a test comment.';
            update task;
        }
   
        
        Account activatedAccount = [SELECT Active__c,Description FROM Account WHERE Id = :acc.Id AND AccountNumber = '003' LIMIT 1];
        System.assertEquals(false, activatedAccount.Active__c);      
    }
    
    // Method To test task is created with the correct details and from Standard User
    @isTest
    static void testTaskCompletionFromStandardUser() {     
        Profile p = [SELECT id, Name FROM Profile where name = 'Standard User'].get(0);  
        User u = new User(firstname= 'Test User1',
  						  lastname='1231',
  						  Alias='t1231',
  						  email = 'test.12341@yopmail.com',
  						  username= 'test.12341@yopmail.com.dev', 
  						  profileId= p.id, 
  						  emailencodingkey='UTF-8',
  						  languagelocalekey='en_US',
  						  localesidkey='en_US',
  						  timezonesidkey='America/Los_Angeles');
  		insert u;	
        System.runAs(u){
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin'];
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
            Account acc = new Account(Name = 'Test Account',AccountNumber = '003', Active__c = false);
            insert acc;   
            
            Task task = [SELECT Id FROM Task WHERE WhatId = :acc.Id LIMIT 1];
            task.Status = 'Completed';
            task.OwnerId = u.Id;
            task.Description = 'This is a test comment.';
            update task;
            
            Account activatedAccount = [SELECT Active__c,Description FROM Account WHERE AccountNumber = '003' LIMIT 1];
        	System.assertEquals(true, activatedAccount.Active__c);   
        }     
    }
    
    
}