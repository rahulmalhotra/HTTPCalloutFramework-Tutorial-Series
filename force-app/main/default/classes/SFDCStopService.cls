/*
*	Author:- Rahul Malhotra
*	Description:- This class is used as a service for all SFDC Stop APIs
*	Created:- 04/04/2020
*	Last Updated:- 04/04/2020
*	Code Origin:- SFDCStop (https://www.sfdcstop.com/)
*	Tutorial:- Simplifying the Callouts in Salesforce Tutorial Series
*/
public with sharing class SFDCStopService {

    public static HTTPResponse getSFDCStopBlogs() {
        HttpCalloutService service = new HTTPCalloutService('SFDCStopBlogs');
        HTTPResponse blogsAPIResponse = service.sendRequest();
        return blogsAPIResponse;
    }
}
