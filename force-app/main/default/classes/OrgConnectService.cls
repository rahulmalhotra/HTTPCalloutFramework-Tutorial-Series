/*
*	Author:- Rahul Malhotra
*	Description:- This apex class is used to interact with APIs of source org
*	Created:- 08/04/2020
*	Last Updated:- 09/04/2020
*	Code Origin:- SFDCStop (https://www.sfdcstop.com/)
*	Tutorial:- Simplifying the Callouts in Salesforce Tutorial Series
*/
public with sharing class OrgConnectService {

    /*
    *	Author:- Rahul Malhotra
    *	Description:- This method is used to perform 3 callouts to source salesforce org
    */
    public static Boolean createAccountAndContact(String accountName, Contact contact) {

        // * Creating account record
        Id accountId = null;
        HTTPCalloutService destinationOrgService = new HTTPCalloutService('CustomerRubyOrg');
        destinationOrgService.setEndpointURL(destinationOrgService.getEndpointURL() + '/sobjects/Account');
        destinationOrgService.setRequestBody(JSON.serialize(new Account(Name = accountName)));
        HTTPResponse accountCreateResponse = destinationOrgService.sendRequest();
        if(accountCreateResponse.getStatusCode() == 201) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(accountCreateResponse.getBody());
            if(Boolean.valueOf(responseMap.get('success'))) {
                accountId = Id.valueOf(String.valueOf(responseMap.get('id')));
                System.debug('Account created with id:- ' + String.valueOf(responseMap.get('id')));
            }
        } else {
            System.debug('Unable to create account');
            return false;
        }

        // * Creating contact record
        Id contactId = null;
        destinationOrgService.setEndpointURL(destinationOrgService.getEndpointURL().substringBeforeLast('Account') + 'Contact');
        contact.AccountId = accountId;
        destinationOrgService.setRequestBody(JSON.serialize(contact));
        HTTPResponse contactCreateResponse = destinationOrgService.sendRequest();
        if(contactCreateResponse.getStatusCode() == 201) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(contactCreateResponse.getBody());
            if(Boolean.valueOf(responseMap.get('success'))) {
                contactId = Id.valueOf(String.valueOf(responseMap.get('id')));
                System.debug('Contact created with id:- ' + String.valueOf(responseMap.get('id')));
            }
        } else {
            System.debug('Unable to create contact');
            return false;
        }

        // * Querying contact and it's related account
        destinationOrgService.setEndpointURL(destinationOrgService.getEndpointURL().substringBeforeLast('sobjects/Contact') + 'query');
        destinationOrgService.setURLParameter('q', 'SELECT+Name,Account.Name+FROM+Contact+WHERE+Id=\''+ contactId +'\'');
        destinationOrgService.setRequestMethod('GET');
        destinationOrgService.setRequestBody(null);
        destinationOrgService.removeHeaderParameter('Content-Type');
        HTTPResponse contactQueryResponse = destinationOrgService.sendRequest();
        if(contactQueryResponse.getStatusCode() == 200) {
            System.debug('Contact with related account:- ' + contactQueryResponse.getBody());
        } else {
            System.debug('Unable to query contact and it\'s realted account');
            return false;
        }
        return true;
    }
}
