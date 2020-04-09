/*
*	Author:- Rahul Malhotra
*	Description:- This apex class is used to interact with APIs of source org
*	Created:- 08/04/2020
*	Last Updated:- 09/04/2020
*	Code Origin:- SFDCStop (https://www.sfdcstop.com/)
*	Tutorial:- Simplifying the Callouts in Salesforce Tutorial Series
*/
public with sharing class OrgConnectService {

    public static final String ACCOUNT_ERROR_MESSAGE = 'Unable to create account';
    public static final String CONTACT_ERROR_MESSAGE = 'Unable to create contact';
    public static final String CONTACT_QUERY_ERROR_MESSAGE = 'Unable to query contact record';
    public static final String SUCCESS_MESSAGE = 'All requests were successful';
    public static final String SUCCESS_CODE = '1';
    public static final String ERROR_CODE = '0';

    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to perform 3 callouts to source salesforce org
    *   one by one where each callout has a dependency on previous callout
    */
    public static Map<String, String> createAccountAndContact(String accountName, Contact contact) {

        Map<String, String> returnValueMap =  new Map<String, String>();

        // * Creating account record
        Id accountId = null;
        HTTPCalloutService destinationOrgService = new HTTPCalloutService('CustomerRubyOrg');
        // * Updating endpoint URL
        destinationOrgService.setEndpointURL(destinationOrgService.getEndpointURL() + '/sobjects/Account');
        // * Updating the request body
        destinationOrgService.setRequestBody(JSON.serialize(new Account(Name = accountName)));
        // * Calling out
        HTTPResponse accountCreateResponse = destinationOrgService.sendRequest();
        if(accountCreateResponse.getStatusCode() == 201) {
            // * Parsing and debugging the account id if request was successful
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(accountCreateResponse.getBody());
            if(Boolean.valueOf(responseMap.get('success'))) {
                accountId = Id.valueOf(String.valueOf(responseMap.get('id')));
                System.debug('Account created with id:- ' + accountId);
            }
        } else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to create account');
            returnValueMap.put('success', ERROR_CODE);
            returnValueMap.put('message', ACCOUNT_ERROR_MESSAGE);
            return returnValueMap;
        }

        // * Creating contact record
        Id contactId = null;
        // * Updating endpoint URL and account id
        destinationOrgService.setEndpointURL(destinationOrgService.getEndpointURL().substringBeforeLast('Account') + 'Contact');
        contact.AccountId = accountId;
        // * Updating the request body
        destinationOrgService.setRequestBody(JSON.serialize(contact));
        // * Calling out
        HTTPResponse contactCreateResponse = destinationOrgService.sendRequest();
        if(contactCreateResponse.getStatusCode() == 201) {
            // * Parsing and debugging the contact id if request was successful
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(contactCreateResponse.getBody());
            if(Boolean.valueOf(responseMap.get('success'))) {
                contactId = Id.valueOf(String.valueOf(responseMap.get('id')));
                System.debug('Contact created with id:- ' + String.valueOf(responseMap.get('id')));
            }
        } else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to create contact');
            returnValueMap.put('success', ERROR_CODE);
            returnValueMap.put('message', CONTACT_ERROR_MESSAGE);
            return returnValueMap;
        }

        // * Querying contact and it's related account
        // * Updating endpoint URL
        destinationOrgService.setEndpointURL(destinationOrgService.getEndpointURL().substringBeforeLast('sobjects/Contact') + 'query');
        // * Updating URL parameter, Request Method, Header and Body
        destinationOrgService.setURLParameter('q', 'SELECT+Name,Account.Name+FROM+Contact+WHERE+Id=\''+ contactId +'\'');
        destinationOrgService.setRequestMethod('GET');
        destinationOrgService.setRequestBody(null);
        destinationOrgService.removeHeaderParameter('Content-Type');
        // * Calling out
        HTTPResponse contactQueryResponse = destinationOrgService.sendRequest();
        if(contactQueryResponse.getStatusCode() == 200) {
            // * Parsing and debugging the response body if request was successful
            System.debug('Contact with related account:- ' + contactQueryResponse.getBody());
        } else {
            // * Debugging and returning error if the request was not successful
            System.debug('Unable to query contact and it\'s realted account');
            returnValueMap.put('success', ERROR_CODE);
            returnValueMap.put('message', CONTACT_QUERY_ERROR_MESSAGE);
            return returnValueMap;
        }
        // * Returning success from method if all the requests were successful
        returnValueMap.put('success', SUCCESS_CODE);
        returnValueMap.put('message', SUCCESS_MESSAGE);
        return returnValueMap;
    }
}
