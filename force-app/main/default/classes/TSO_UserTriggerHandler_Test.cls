@IsTest
private class TSO_UserTriggerHandler_Test {
 
    static testMethod void TestUserTriggerHandlerBasicFunctions(){
 
        Profile p = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' ];
        User u = new User();
        u.FirstName = 'User1';
        u.LastName = 'UserAfterUpdate';
        u.Username = u.FirstName + '' + u.LastName + '@testclassUser.com';
        u.ProfileId = p.Id;
        u.Email = 'UserAfterUpdate@abc.com';
        u.Alias = 'usr123';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.Street = '1234 ABC St';
        u.City = 'NYC';
        u.PostalCode = '23456';
        u.State = 'NY';
        u.Phone = '2345678965';
        u.Fax = '2345678965';
 
        insert u;
 
        // Update User
 
        u.FirstName = 'updated Test';
 
        update u;
 
        System.assertEquals( u.FirstName, [ SELECT Id, FirstName FROM User WHERE Id =: u.Id ].FirstName );
    }
}