/*
*	Author:- Rahul Malhotra
*	Description:- This is the test cass for OrgConnectService class
*	Created:- 09/04/2020
*	Last Updated:- 09/04/2020
*	Code Origin:- SFDCStop (https://www.sfdcstop.com/)
*	Tutorial:- Simplifying the Callouts in Salesforce Tutorial Series
*/
@isTest
public with sharing class OrgConnectServiceTest {

    public static final String CONTACT_RESPONSE = '{ "id" : "003D000000IqhSLIAZ", "errors" : [ ], "success" : true }';
    public static final String ACCOUNT_RESPONSE = '{ "id" : "001D000000IqhSLIAZ", "errors" : [ ], "success" : true }';
    public static final String QUERY_RESPONSE = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Contact","url":"/services/data/v48.0/sobjects/Contact/003D000000IqhSLIAZ"},"Name":"Test Contact 1","Account":{"attributes":{"type":"Account","url":"/services/data/v48.0/sobjects/Account/001D000000IqhSLIAZ"},"Name":"Test Account 1"}}]}';
    public static final Integer CREATE_SUCCESS_CODE = 201;
    public static final Integer QUERY_SUCCESS_CODE = 200;

    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to cover positive scenario while executing
    *                 createAccountAndContact() method of OrgConnectService class
    */
    @isTest
    public static void createAccountAndContactTest() {
        Test.startTest();
        // * Creating Individual Mocks
        HTTPCalloutServiceMock contactMock = new HTTPCalloutServiceMock(CREATE_SUCCESS_CODE, CONTACT_RESPONSE);
        HTTPCalloutServiceMock accountMock = new HTTPCalloutServiceMock(CREATE_SUCCESS_CODE, ACCOUNT_RESPONSE);
        HTTPCalloutServiceMock contactQueryMock = new HTTPCalloutServiceMock(QUERY_SUCCESS_CODE, QUERY_RESPONSE);
        // * Adding all individual mocks in single multi mock
        HTTPCalloutService destinationOrgService = new HTTPCalloutService('CustomerRubyOrg');
        HTTPCalloutServiceMultiMock multiMock = new HTTPCalloutServiceMultiMock();
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/sobjects/Account', accountMock);
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/sobjects/Contact', contactMock);
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/query?q=SELECT+Name,Account.Name+FROM+Contact+WHERE+Id=\'003D000000IqhSLIAZ\'', contactQueryMock);
        // * Applying multi mock before calling out
        Test.setMock(HTTPCalloutMock.class, multiMock);
        Contact con = new Contact(FirstName='Test', LastName='Contact 1');
        Map<String, String> returnValueMap = OrgConnectService.createAccountAndContact('Test Account 1', con);
        // * Verifying the response
        System.assertEquals(OrgConnectService.SUCCESS_CODE, returnValueMap.get('success'), 'Success should be ' + OrgConnectService.SUCCESS_CODE);
        System.assertEquals(OrgConnectService.SUCCESS_MESSAGE, returnValueMap.get('message'), 'Message should be ' + OrgConnectService.SUCCESS_MESSAGE);
        Test.stopTest();
    }

    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to cover negative scenario
    *   i.e. wrong response from account creation while executing
    *   createAccountAndContact() method of OrgConnectService class
    */
    @isTest
    public static void createAccountAndContactTestWrongResponseAccount() {
        Test.startTest();
        // * Creating Individual Account Mock
        HTTPCalloutServiceMock accountMock = new HTTPCalloutServiceMock(QUERY_SUCCESS_CODE, ACCOUNT_RESPONSE);
        /*
        *   Setting up account mock only before calling out
        *   As we'll be having error in the first request itself,
        *   so multi-mock is not required
        */
        Test.setMock(HTTPCalloutMock.class, accountMock);
        Contact con = new Contact(FirstName='Test', LastName='Contact 1');
        Map<String, String> returnValueMap = OrgConnectService.createAccountAndContact('Test Account 1', con);
        // * Verifying the response
        System.assertEquals(OrgConnectService.ERROR_CODE, returnValueMap.get('success'), 'Success should be ' + OrgConnectService.ERROR_CODE);
        System.assertEquals(OrgConnectService.ACCOUNT_ERROR_MESSAGE, returnValueMap.get('message'), 'Message should be ' + OrgConnectService.ACCOUNT_ERROR_MESSAGE);
        Test.stopTest();
    }

    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to cover negative scenario
    *   i.e. wrong response from contact creation while executing
    *   createAccountAndContact() method of OrgConnectService class
    */
    @isTest
    public static void createAccountAndContactTestWrongResponseContact() {
        Test.startTest();
        // * Creating Individual Mocks
        HTTPCalloutServiceMock accountMock = new HTTPCalloutServiceMock(CREATE_SUCCESS_CODE, ACCOUNT_RESPONSE);
        HTTPCalloutServiceMock contactMock = new HTTPCalloutServiceMock(QUERY_SUCCESS_CODE, CONTACT_RESPONSE);
        // * Adding all individual mocks in single multi mock
        HTTPCalloutService destinationOrgService = new HTTPCalloutService('CustomerRubyOrg');
        HTTPCalloutServiceMultiMock multiMock = new HTTPCalloutServiceMultiMock();
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/sobjects/Account', accountMock);
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/sobjects/Contact', contactMock);
        // * Applying multi mock before calling out
        Test.setMock(HTTPCalloutMock.class, multiMock);
        Contact con = new Contact(FirstName='Test', LastName='Contact 1');
        Map<String, String> returnValueMap = OrgConnectService.createAccountAndContact('Test Account 1', con);
        // * Verifying the response
        System.assertEquals(OrgConnectService.ERROR_CODE, returnValueMap.get('success'), 'Success should be ' + OrgConnectService.ERROR_CODE);
        System.assertEquals(OrgConnectService.CONTACT_ERROR_MESSAGE, returnValueMap.get('message'), 'Message should be ' + OrgConnectService.CONTACT_ERROR_MESSAGE);
        Test.stopTest();
    }
    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to cover negative scenario
    *   i.e. wrong response from contact query while executing
    *   createAccountAndContact() method of OrgConnectService class
    */
    @isTest
    public static void createAccountAndContactTestWrongResponseQuery() {
        Test.startTest();
        // * Creating Individual Mocks
        HTTPCalloutServiceMock accountMock = new HTTPCalloutServiceMock(CREATE_SUCCESS_CODE, ACCOUNT_RESPONSE);
        HTTPCalloutServiceMock contactMock = new HTTPCalloutServiceMock(CREATE_SUCCESS_CODE, CONTACT_RESPONSE);
        HTTPCalloutServiceMock contactQueryMock = new HTTPCalloutServiceMock(CREATE_SUCCESS_CODE, QUERY_RESPONSE);
        // * Adding all individual mocks in single multi mock
        HTTPCalloutService destinationOrgService = new HTTPCalloutService('CustomerRubyOrg');
        HTTPCalloutServiceMultiMock multiMock = new HTTPCalloutServiceMultiMock();
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/sobjects/Account', accountMock);
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/sobjects/Contact', contactMock);
        multiMock.addCalloutMock(destinationOrgService.getEndpointURL() + '/query?q=SELECT+Name,Account.Name+FROM+Contact+WHERE+Id=\'003D000000IqhSLIAZ\'', contactQueryMock);
        // * Applying multi mock before calling out
        Test.setMock(HTTPCalloutMock.class, multiMock);
        Contact con = new Contact(FirstName='Test', LastName='Contact 1');
        Map<String, String> returnValueMap = OrgConnectService.createAccountAndContact('Test Account 1', con);
        // * Verifying the response
        System.assertEquals(OrgConnectService.ERROR_CODE, returnValueMap.get('success'), 'Success should be ' + OrgConnectService.ERROR_CODE);
        System.assertEquals(OrgConnectService.CONTACT_QUERY_ERROR_MESSAGE, returnValueMap.get('message'), 'Message should be ' + OrgConnectService.CONTACT_QUERY_ERROR_MESSAGE);
        Test.stopTest();
    }
}