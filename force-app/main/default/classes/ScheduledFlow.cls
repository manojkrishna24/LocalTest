global class ScheduledFlow implements Schedulable {
   global void execute(SchedulableContext sc) {
       Map<String, Id> params = new Map<String, Id> ();
       		Flow.Interview kycScoringFlow = Flow.Interview.createInterview('MissingCaseNotification',params );
			kycScoringFlow.start();
   }
}