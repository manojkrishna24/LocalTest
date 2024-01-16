public class ReviewGen {

    public static String generateRisksAndIssues(Date refDate) {
        
        Boolean isEmpty = true;
        
        Integer deltaDays = refDate.daysBetween(system.today());
		
        String review = '<strong>Issues & Risks</strong>';
     	
		String htmlResult = '<table>'
						+'<thead>'
        				+'<tr style="border : 1px solid black">'
            			+'<th>Id</th>'
            			+'<th>Title</th>'
            			+'<th>Criticality</th>' 
						+'<th></th>'             
        				+'</tr>'
    					+'</thead>'
    					+'<tbody>';
       
       String query =  'SELECT CreatedDate, Id, Id__c, toLabel(Status__c), Description__c, toLabel(Criticality__c), Name, Owner.Name '
					 + 'FROM IssueRisk__c WHERE (LastModifiedDate >= LAST_N_DAYS:' + deltaDays + ' OR Status__c = \'Open\')' 
					 + 'AND Status__c != \'Cancelled\''
					 + 'ORDER BY Criticality__c';
        
        for(IssueRisk__c issueOrRisk:Database.query(query)) {
         	
            isEmpty = false;
			String reviewStatus = '';
                                            
			if(issueOrRisk.CreatedDate > refDate) {
				reviewStatus = '✴️ New';
			}
			
			if(issueOrRisk.Status__c == '✅ Closed') {
				reviewStatus = '✅ Closed';
			}
                                            
			String intermediaryResult = '<tr style="border : 1px solid black">'
                +'<td>'+issueOrRisk.Id__c+'</td>'
                +'<td>'+issueOrRisk.Name+'</td>'
                +'<td>'+issueOrRisk.Criticality__c+'</td>'                    
                +'<td>'+reviewStatus+'</td>'                                        
                +'</tr>';     
                                            
			htmlResult += intermediaryResult;                                                                                    
        }
            
		htmlResult +=  '</tbody>' + '</table>';                
		
        if(!isEmpty) {
        	review += htmlResult;    
        }
        else {
            review = '';
        }
        
        return review;
    }
    
    public static String getDelta(Date refDate) {
        
        Integer theDay 	= refDate.Day();
        String theDayString = theDay < 10 ? '0' + theDay : '' + theDay;
        
        Integer theMonth = refDate.Month();
        String theMonthString = theMonth < 10 ? '0' + theMonth : '' + theMonth;
        
        String refDateString;  // theDayString + '/' + theMonthString;
        
		Integer diffDays = system.today().daysBetween(refDate);

        if(diffDays == -1) {
            refDateString = 'Yesterday';
        }
        else {
            refDateString = dayOfWeek(refDate);
        }
        
        return refDateString;
        
        // return refDateString;
    }
    
    public static String generateActions(Date refDate) {
        
        Integer deltaDays = refDate.daysBetween(system.today());
        deltaDays = deltaDays < 0 ? 0 : deltaDays;
        
        String refDateString = getDelta(refDate);
		
        Boolean isEmpty = true;
        String review = '<strong>Actions</strong>';
        
		String htmlResult = '<table>'
						+'<thead>'
        				+'<tr style="border : 1px solid black">'
            			+'<th>Id</th>'
            			+'<th>Title</th>' 
            			+'<th>Assigned To</th>'             
            			+'<th>Due Date</th>'  
						+'<th>Since ' +refDateString+'</th>'              
        				+'</tr>'
    					+'</thead>'
    					+'<tbody>';
        
        String query = 'SELECT Id, CreatedDate, Id__c, Status__c, DueDateFormula__c, Name, Owner.Name, DueDate__c, '
					   +' AssignedTo__r.Name '
            		   +'FROM Action__c WHERE Status__c = \'Open\' OR '
                       +'LastModifiedDate >= LAST_N_DAYS:' + deltaDays + ' ORDER BY DueDate__c ASC'; 
        
        system.debug('query : ' + query);
        
        for(Action__c action:Database.query(query)) {
            
			String reviewStatus = '';
            isEmpty = false;
            
           
            system.debug(action.CreatedDate > refDate);
           
			if(action.CreatedDate > refDate.addDays(1)) {
				reviewStatus = '✴️&nbsp;New';
			}
			
			if(action.Status__c == 'Completed') {
				reviewStatus = '✅&nbsp;Closed';
			}
			
            String dueDate = action.DueDate__c.Day()+'/'+action.DueDate__c.Month() + '/'+action.DueDate__c.Year();
            Integer diffDays = system.today().daysBetween(action.DueDate__c);
            String weekday = dayOfWeek(action.DueDate__c);
            
			if(diffDays == 0) {
                dueDate = '<strong>Today</strong>';
            }
            if(diffDays == 1) {
                dueDate = '<strong>Tomorrow</strong>';
            }
            else if(diffDays == -1) {
                dueDate = '<p style="color:#D72E2D;">️Yesterday</p>';
            }
            else if(diffDays < -1) {
                
                if(action.Status__c == 'Open') {
                    dueDate = '<p style="color:#D72E2D;">️' + dueDate + ' </p>';    
                }                     
            }
            else if(diffDays > 1 && diffDays <= 7) {
                dueDate = weekday;                
            }
            else if(diffDays > 7 ) {
                dueDate = weekday;                
            }            
            
			String intermediaryResult = '<tr style="border : 1px solid black">';
            
            if(action.Status__c == 'Completed') {
                intermediaryResult = '<tr style="border : 1px solid black; color : grey;">';
            }
            
            intermediaryResult += '<td>'+action.Id__c+'</td>'
                            	+'<td>'+action.Name+'</td>' 
                            	+'<td>'+action.AssignedTo__r.Name+'</td>'                 
                				+'<td>'+dueDate+'</td>'
                				+'<td>'+reviewStatus+'</td>'                
                            	+'</tr>';    
            
			htmlResult += intermediaryResult;                                   
        }
            
		htmlResult +=  '</tbody>' + '</table>';                
		
    	if(!isEmpty) {
        	review += htmlResult;    
        }
        else {
            review = '';
        }
                
        return review;
    }
    
    public static String generateOpenPoints(Date refDate) {
        
        Boolean isEmpty = true;
        Integer deltaDays = refDate.daysBetween(system.today());
        
        String refDateString = getDelta(refDate);
        
		String review = '<strong>Open Points</strong>';
     
		String htmlResult = '<table>'
						+'<thead>'
        				+'<tr style="border : 1px solid black">'
            			+'<th>Id</th>'
            			+'<th>Description</th>'
						+'<th>Since ' +refDateString+'</th>'                       
        				+'</tr>'
    					+'</thead>'
    					+'<tbody>';
        
        String query = 'SELECT Id, Id__c, CreatedDate, Status__c, Name, Description__c '
            		 + 'FROM OpenPoint__c WHERE Status__c = \'Open\' OR LastModifiedDate >= LAST_N_DAYS:' 
            		 + deltaDays + ' ORDER BY CreatedDate DESC';
        
        for(OpenPoint__c op:Database.query(query)) {
         
            String reviewStatus = '';
            isEmpty = false;
            
			if(op.CreatedDate > refDate.addDays(1)) {
				reviewStatus = '✴️&nbsp;New';
			}
			
			if(op.Status__c == 'Completed') {
				reviewStatus = '✅&nbsp;Closed';
			}            
            
			String intermediaryResult = '<tr style="border : 1px solid black">'
                            +'<td>'+op.Id__c+'</td>'
                            +'<td>'+op.Name+'</td>'                  
							+'<td>' + reviewStatus + '</td>'                                  
                            +'</tr>';     
			htmlResult += intermediaryResult;                                   
        }
            
		htmlResult +=  '</tbody>' + '</table>';                

    	if(!isEmpty) {
        	review += htmlResult;    
        }
        else {
            review = '';
        }
        
        return review;
    }    

    public static void generateProjectReview(Id projectReviewId) {
		
        ProjectReview__c pr = [SELECT Id, PMO__c, LastProjectReviewDate__c FROM ProjectReview__c WHERE ID = :projectReviewId];
        
        String actionReview = generateActions(pr.LastProjectReviewDate__c); 
        String opReview = generateOpenPoints(pr.LastProjectReviewDate__c); 
		String riskAndIssues = generateRisksAndIssues(pr.LastProjectReviewDate__c);
        
        pr.PMO__c = riskAndIssues + '<br/><br/>' + actionReview + '<br/><br/>' + opReview ;
        update pr;
    }
    
    public static String dayOfWeek(Date aDate) {
        
        String dayOfWeek;
        Integer weekDayNumber = Math.mod(Date.newInstance(1900, 1, 7).daysBetween(aDate),7);
        
        switch on weekDayNumber {
            when 0 { dayOfWeek = 'Sunday'; }            	
            when 1 { dayOfWeek = 'Monday'; }
            when 2 { dayOfWeek = 'Tuesday'; }
            when 3 { dayOfWeek = 'Wednesday'; }     
            when 4 { dayOfWeek = 'Thursday'; }                 
            when 5 { dayOfWeek = 'Friday'; }                      
            when 6 { dayOfWeek = 'Saturday'; }                                  
            when else { }
        }
        
        return dayOfWeek;
    }    
    
}