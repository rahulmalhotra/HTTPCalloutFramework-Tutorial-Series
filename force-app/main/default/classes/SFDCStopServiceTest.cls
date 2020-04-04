/*
*	Author:- Rahul Malhotra
*	Description:- This class is the test class for SFDCStopService class
*	Created:- 04/04/2020
*	Last Updated:- 04/04/2020
*	Code Origin:- SFDCStop (https://www.sfdcstop.com/)
*	Tutorial:- Simplifying the Callouts in Salesforce Tutorial Series
*/
@isTest
public with sharing class SFDCStopServiceTest {

    public static final Integer RESPONSE_CODE = 200;
    public static final String RESPONSE_BODY = '{"author":"Rahul Malhotra","blogs":[{"id":"1","title":"Salesforce Integration Tutorial Part 1 - Introduction and Setting up Workbench","url":"https://www.sfdcstop.com/2019/11/salesforce-integration-tutorial-part-1.html"},{"id":"2","title":"Salesforce Integration Tutorial Part 2 - Exploring GET Method","url":"https://www.sfdcstop.com/2019/11/salesforce-integration-tutorial-part-2.html"}]}';

    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to test getSFDCStopBlogs method from SFDCStopService class
    */
    @isTest
    public static void getSFDCStopBlogsTest() {
        Test.startTest();
        HTTPCalloutServiceMock serviceMock = new HTTPCalloutServiceMock(RESPONSE_CODE, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, serviceMock);
        HTTPResponse blogsResponse = SFDCStopService.getSFDCStopBlogs();
        System.assertEquals(RESPONSE_CODE, blogsResponse.getStatusCode(), 'Response code should be ' + RESPONSE_CODE);
        System.assertEquals(RESPONSE_BODY, blogsResponse.getBody(), 'Response body should be:- ' + RESPONSE_BODY);
        Test.stopTest();
    }
}