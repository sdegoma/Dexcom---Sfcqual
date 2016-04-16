/***********************************************
* Class newordercheckinghelper R01
* @Author : Venkat Kollimerla
* Date : 15 December 2014
* 
* R02
* @Author : Chuck Nothdurft
* Date : 2 April 2015
* Incorporation of notes, limited positive results to those where OH Type is Standard Sales Order.
* @Description : This class is used by the neworderchecking trigger to identify records that should be added to the PCS call list.
* Order Item Records are set to Check Call List = True, which allows for Workflows to pick up the delayed assignment to the call list.
* This class limits OID records that can be set to Check Call List = True to those OIDs where:
*    1. Related Order Header is for Standard Sales Order
*    2. OID object type is not on blocked list
*    3. Account's last kit purchase is over 2 years prior.
*
*      Change Log
* #    Date     Programmer               Change Description
* ==== ======== ======================== =============================================
*   01 05/19/15 Brian Uyeda              Trigger was not working for bulk loads, modified code
*                                        to work for single and bulk updates
***********************************************/

Public Class newordercheckinghelper{ // Name the Class and Start
}