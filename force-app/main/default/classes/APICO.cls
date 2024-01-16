public class APICO {
    
    private static String telegramAlertAPI = System.Label.EndpointTelegramAPICO;
    private static String telegramAlertAPIMethodType = 'POST';
    
   @future(callout=true)
   public static void callJBonResolved(String caseId,Boolean isCaseResumed) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
       	telegramAlertAPI=isCaseResumed ? telegramAlertAPI+'?Id='+caseId+'&&CaseResumed=true' : telegramAlertAPI+'?Id='+caseId+'&&CaseResumed=false';
       	System.debug('API Endpoint : '+telegramAlertAPI);
       	request.setEndpoint(telegramAlertAPI);
        request.setMethod(telegramAlertAPIMethodType);
       	HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
			System.debug('Telegram Alert API call Success');
        }
       else
           System.debug('Telegram Alert API Callout Failed');
      }
}