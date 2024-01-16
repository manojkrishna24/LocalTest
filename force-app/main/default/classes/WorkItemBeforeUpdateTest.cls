@isTest
private class WorkItemBeforeUpdateTest {
    
    @Testsetup
    static void makeData()
    {   
        PermissionSet pSet = [SELECT Id From PermissionSet WHERE Name='SpringProject_admin'];        
        Profile p=[SELECT Id From Profile WHERE Name = 'System Administrator' or Name = 'Administrateur système'];
        
        User u =new User( Alias = 'newUser1' ,
                         Email ='newuser123@testorg.com',
                         EmailEncodingKey = 'UTF-8',
                         LastName = 'Testing',
                         LanguageLocaleKey='en_US',
                         LocaleSidKey='en_US',
                         UserName='newuser555@testorg.com',
                         ProfileId=p.Id,
                         TimeZoneSidKey='America/Los_Angeles');
        insert u;
        
        PermissionSetAssignment ps = new PermissionSetAssignment();
        ps.AssigneeId = u.id;
        ps.PermissionSetId = pSet.id;
        
        WorkItem__c workItem1 = new WorkItem__c();
        workItem1.Description__c = '<p><br></p><p><strong><strong>As a</strong></strong> Sales <strong><strong>As a</strong> <br><strong>I want</strong> to <br><strong>So that</strong></strong></p><p><br></p><p><br></p><p><strong>I want</strong> to Do this</p><p><br></p><p><br></p><p><strong>So that</strong> i can check that</p>';
        workItem1.AssignedTo__c=u.id;
        insert workItem1;
    }
    
    @isTest
    static void testUpdate(){
        Test.startTest();
        try {
            WorkItem__c witem1 = [Select Description__c from WorkItem__c];
            witem1.Description__c='<p><br></p><p><strong><strong>sc z</strong></strong> Sales <strong><strong>zzz z</strong> <br><strong>bb vv</strong> to <br><strong>bbb bbbb</strong></strong></p><p><br></p><p><br></p><p><strong>cv vf</strong> to Do this</p><p><br></p><p><br></p><p><strong>fvdf that</strong> dvf can check that</p>';
            update witem1;
            
            //if 'As a'
        	witem1.Description__c = '<p><br></p><p><strong><strong>As a</strong></strong> Sales <strong><strong>As a</strong> <br><strong>I want</strong> to <br><strong>So that</strong></strong></p><p><br></p><p><br></p><p><strong>I want</strong> to Do this</p><p><br></p><p><br></p><p><strong>So that</strong> i can check that</p>';
            update witem1;
            
            //if 'I want'
            witem1.Description__c = '<p><br></p><p><strong><strong>ss</strong></strong> Sales <strong><strong>dsd</strong> <br><strong>I want</strong> to <br><strong>So that</strong></strong></p><p><br></p><p><br></p><p><strong>I want</strong> to Do this</p><p><br></p><p><br></p><p><strong>So that</strong> i can check that</p>';
            update witem1;
            
            //if 'so that'
            witem1.Description__c = '<p><br></p><p><strong><strong>sdsd</strong></strong> Sales <strong><strong>sdsd</strong> <br><strong>sdsds</strong> to <br><strong>so that</strong></strong></p><p><br></p><p><br></p><p><strong>I want</strong> to Do this</p><p><br></p><p><br></p><p><strong>so that</strong> i can check that</p>';
            update witem1;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('You must enforce the User Story format « As a ... I want ... so that »') ? true : false;
            if(expectedExceptionThrown){
                System.assertEquals(expectedExceptionThrown, true);
            }else{
                System.assertEquals(expectedExceptionThrown, false);
            }
        } 
    }
}