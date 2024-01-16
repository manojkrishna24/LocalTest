public class ExcelToCaseAPI {
    private static String excelCaseCreationAPIEndpoint = System.Label.EndpointCaseCreation;
    private static String excelCaseCreationAPIMethodType = 'PATCH';
    private static String outageClosureAPIEndpoint = System.Label.EndpointCaseCreation;
    private static String outageClosureAPIMethodType = 'PUT';

    @future(callout=true)
   	public static void makeGetCallout(String contactId, String subject, String caseId, String sfMailId) {
       DateTime start = System.now();
       while(System.now().getTime()<start.getTime()+2000){}
        List<ContentDocumentLink> cdls = [Select Id, ContentDocumentId, LinkedEntityId, ContentDocument.LatestPublishedVersionId, 
                                                  ContentDocument.FileExtension, ContentDocument.FileType from ContentDocumentLink where 
                                                  LinkedEntityId = :sfMailId and 
                                                  (ContentDocument.FileExtension='xlsx' or ContentDocument.FileExtension='xlsb')];
        		System.debug('Excel To Case API - Small Cell - CDL query - CDL Size :' + cdls.size());
                if(cdls.size()>0)
                {
                    /*for(Integer i=0; i<cdls.size(); i++){if(i==0)
                        CVIds = cdls[i].ContentDocument.LatestPublishedVersionId;else
                            CVIds = CVIds + ',' + cdls[i].ContentDocument.LatestPublishedVersionId;}*/
                    List<ContentVersion> cvObjs = [Select id, Title, FileExtension,VersionData,CreatedDate 
                                                   from ContentVersion where Id=:cdls[0].ContentDocument.LatestPublishedVersionId];
                    if(cvObjs.size()>0)
                    {
                        String fileName = cvObjs[0].Title;
                        String cvId = cvObjs[0].Id;
                       System.debug('Email Message On Insert - Small Cell - cvobjs Query - cvobjs Size :' + cvObjs.size()
                                     + 'cvobjs Title :' + cvObjs[0].Title);
                        if(fileName.contains(System.Label.ExcelToCaseAPIAlarmDetail) || fileName.contains(System.Label.ExcelToCaseAPISITEDOWN) || fileName.contains(System.Label.ExcelToCaseAPIOutage))
                       {
                           system.debug('content version case creation from excel : ' + cvId);
                           Http http = new Http();
                           HttpRequest request = new HttpRequest();
                           Subject = Subject.replaceAll(' ','').trim();
                           if(fileName.contains(System.Label.ExcelToCaseAPIAlarmDetail)){
                               request.setEndpoint(excelCaseCreationAPIEndpoint+'?ContactEmail='+contactId+'&Id='+cvId+'&Subject='+Subject+'&AccountName=Airtel');
                           	   request.setMethod(excelCaseCreationAPIMethodType);
                           }else if(fileName.contains(System.Label.ExcelToCaseAPISITEDOWN)){ //every one hour incidents are reported in this excel
                               request.setEndpoint(excelCaseCreationAPIEndpoint+'?ContactEmail='+contactId+'&Id='+cvId+'&Subject='+Subject+'&AccountName=Vodafone');
                               request.setMethod(excelCaseCreationAPIMethodType);
                           }else if (fileName.contains(System.Label.ExcelToCaseAPIOutage)){ //every 24 hours closure time is reported by vodafone in this xlsb file in email
                               system.debug('CVId3 Closure : ' + cvId);
                               request.setEndpoint(outageClosureAPIEndpoint+'?Id='+cvId);
                               request.setMethod(outageClosureAPIMethodType);
                           }
                           HttpResponse response = http.send(request);
                           if(response.getStatusCode() == 200)
                               System.debug('Excel to Case API call - first mail');
                           else
                           {
                               System.debug(response.getBody());
                               System.debug('Excel to Case first mail - API Callout Failed');
                           }   
                       }else
                            System.debug('ExcelToCaseAPI no call made because file name is not airtel or sitedown or outage');
                     }
                    }
                }
}