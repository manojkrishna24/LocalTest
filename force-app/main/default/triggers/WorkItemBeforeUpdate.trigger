trigger WorkItemBeforeUpdate on WorkItem__c (before Update) {
	for(WorkItem__c wi:Trigger.New) {
        
        if(String.isNotEmpty(wi.Description__c)){
            //To throw error if the Description field missing the expected format
        	//User_story_Description_Format - Custom Label to turn Off/On the error 
            if(Label.User_story_Description_Format == 'true' && ( !wi.Description__c?.containsIgnoreCase ('As a') 
               || !wi.Description__c?.containsIgnoreCase ('I want') 
               || !wi.Description__c?.containsIgnoreCase ('so that') ) ){
                
                   wi.Description__c.addError('You must enforce the User Story format « As a ... I want ... so that »');
            }
            else{
                //Checking for the expected value if it is there then formating it
                if(wi.Description__c?.containsIgnoreCase ('As a')){
                    wi.Description__c = wi.Description__c.replace(wi.Description__c.substring(wi.Description__c.indexOfIgnoreCase('As a'),
                                        wi.Description__c.indexOfIgnoreCase('As a') + 4), '<strong>As a</strong>');   
                }
                if(wi.Description__c?.containsIgnoreCase ('I want')){
                    wi.Description__c = wi.Description__c.replace(wi.Description__c.substring(wi.Description__c.indexOfIgnoreCase('i want'),
                                        wi.Description__c.indexOfIgnoreCase('i want') + 6), '<br/><strong>I want</strong>');
                }
                if(wi.Description__c?.containsIgnoreCase ('so that')){
                    wi.Description__c = wi.Description__c.replace(wi.Description__c.substring(wi.Description__c.indexOfIgnoreCase('so that'),
                                        wi.Description__c.indexOfIgnoreCase('so that') + 7), '<br/><strong>So that</strong>');
                }
            }
        }     
    }
}