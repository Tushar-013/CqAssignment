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
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];

        // Retrieve the inserted account and verify its Active status
        Account insertedAccount = [SELECT Active__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.assertEquals(false, insertedAccount.Active__c);
    }
}