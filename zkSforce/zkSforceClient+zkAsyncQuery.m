// Copyright (c) 2011,2013 Jonathan Hersh, Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//

#import "ZKSforceClient+zkAsyncQuery.h"

@implementation ZKSforceClient (zkAsyncQuery)

-(BOOL)confirmLoggedIn {
	if (![self loggedIn]) {
		NSLog(@"ZKSforceClient does not have a valid session. request not executed");
		return NO;
	}
	return YES;
}
// This method implements the meat of all the perform* calls,
// it handles making the relevant call in a background thread/queue, 
// and then calling the fail or complete block on the UI thread.
// You don't appear to be able to have generic type'd blocks
// so the perform* methods all have shim completeBlock to cast 
// back to the relevant type from NSObject * that's used here.
//
-(void)performRequest:(NSObject * (^)(void))requestBlock 
            failBlock:(zkFailWithExceptionBlock)failBlock 
        completeBlock:(void (^)(NSObject *))completeBlock {

    // sanity check that we're actually logged in and ready to go.
    if (![self confirmLoggedIn]) return;

   // run this block async on the default queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        @try {
            NSObject *result = requestBlock();
            // run the completeBlock on the main thread.
            dispatch_async(dispatch_get_main_queue(), ^(void) {            
                completeBlock(result);
            });

        } @catch (NSException *ex) {
           // run the failBlock on the main thread.
            if (failBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    failBlock(ex);
                });
            }
        }
	});
}

// Login to the Salesforce.com SOAP Api
-(void) performLogin:(NSString *)username password:(NSString *)password
           failBlock:(zkFailWithExceptionBlock)failBlock
       completeBlock:(zkCompleteLoginResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self login:username password:password];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKLoginResult *)r);
		}];
}

// Describe an sObject
-(void) performDescribeSObject:(NSString *)sObjectType
                     failBlock:(zkFailWithExceptionBlock)failBlock
                 completeBlock:(zkCompleteDescribeSObjectBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeSObject:sObjectType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeSObject *)r);
		}];
}

// Describe a number sObjects
-(void) performDescribeSObjects:(NSArray *)sObjectType
                      failBlock:(zkFailWithExceptionBlock)failBlock
                  completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeSObjects:sObjectType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe the Global state
-(void) performDescribeGlobalWithFailBlock:(zkFailWithExceptionBlock)failBlock
                completeBlock:(zkCompleteDescribeGlobalResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeGlobal];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeGlobalResult *)r);
		}];
}

// Describe all the data category groups available for a given set of types
-(void) performDescribeDataCategoryGroups:(NSArray *)sObjectType
                                failBlock:(zkFailWithExceptionBlock)failBlock
                            completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeDataCategoryGroups:sObjectType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe the data category group structures for a given set of pair of types and data category group name
-(void) performDescribeDataCategoryGroupStructures:(NSArray *)pairs topCategoriesOnly:(BOOL)topCategoriesOnly
                                         failBlock:(zkFailWithExceptionBlock)failBlock
                                     completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeDataCategoryGroupStructures:pairs topCategoriesOnly:topCategoriesOnly];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe a list of FlexiPage and their contents
-(void) performDescribeFlexiPages:(NSArray *)flexiPages
                        failBlock:(zkFailWithExceptionBlock)failBlock
                    completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeFlexiPages:flexiPages];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe the items in an AppMenu
-(void) performDescribeAppMenu:(NSString *)appMenuType
                     failBlock:(zkFailWithExceptionBlock)failBlock
                 completeBlock:(zkCompleteDescribeAppMenuResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeAppMenu:appMenuType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeAppMenuResult *)r);
		}];
}

// Describe Gloal and Themes
-(void) performDescribeGlobalThemeWithFailBlock:(zkFailWithExceptionBlock)failBlock
                     completeBlock:(zkCompleteDescribeGlobalThemeBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeGlobalTheme];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeGlobalTheme *)r);
		}];
}

// Describe Themes
-(void) performDescribeTheme:(NSArray *)sobjectType
                   failBlock:(zkFailWithExceptionBlock)failBlock
               completeBlock:(zkCompleteDescribeThemeResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeTheme:sobjectType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeThemeResult *)r);
		}];
}

// Describe the layout of the given sObject or the given actionable global page.
-(void) performDescribeLayout:(NSString *)sObjectType recordTypeIds:(NSArray *)recordTypeIds
                    failBlock:(zkFailWithExceptionBlock)failBlock
                completeBlock:(zkCompleteDescribeLayoutResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeLayout:sObjectType recordTypeIds:recordTypeIds];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeLayoutResult *)r);
		}];
}

// Describe the layout of the SoftPhone
-(void) performDescribeSoftphoneLayoutWithFailBlock:(zkFailWithExceptionBlock)failBlock
                         completeBlock:(zkCompleteDescribeSoftphoneLayoutResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeSoftphoneLayout];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeSoftphoneLayoutResult *)r);
		}];
}

// Describe the search view of an sObject
-(void) performDescribeSearchLayouts:(NSArray *)sObjectType
                           failBlock:(zkFailWithExceptionBlock)failBlock
                       completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeSearchLayouts:sObjectType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe a list of objects representing the order and scope of objects on a users search result page
-(void) performDescribeSearchScopeOrderWithFailBlock:(zkFailWithExceptionBlock)failBlock
                          completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeSearchScopeOrder];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe the compact layouts of the given sObject
-(void) performDescribeCompactLayouts:(NSString *)sObjectType recordTypeIds:(NSArray *)recordTypeIds
                            failBlock:(zkFailWithExceptionBlock)failBlock
                        completeBlock:(zkCompleteDescribeCompactLayoutsResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeCompactLayouts:sObjectType recordTypeIds:recordTypeIds];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKDescribeCompactLayoutsResult *)r);
		}];
}

// Describe the tabs that appear on a users page
-(void) performDescribeTabsWithFailBlock:(zkFailWithExceptionBlock)failBlock
              completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeTabs];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Create a set of new sObjects
-(void) performCreate:(NSArray *)sObjects
            failBlock:(zkFailWithExceptionBlock)failBlock
        completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self create:sObjects];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Update a set of sObjects
-(void) performUpdate:(NSArray *)sObjects
            failBlock:(zkFailWithExceptionBlock)failBlock
        completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self update:sObjects];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Update or insert a set of sObjects based on object id
-(void) performUpsert:(NSString *)externalIDFieldName sObjects:(NSArray *)sObjects
            failBlock:(zkFailWithExceptionBlock)failBlock
        completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self upsert:externalIDFieldName sObjects:sObjects];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Merge and update a set of sObjects based on object id
-(void) performMerge:(NSArray *)request
           failBlock:(zkFailWithExceptionBlock)failBlock
       completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self merge:request];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Delete a set of sObjects
-(void) performDelete:(NSArray *)ids
            failBlock:(zkFailWithExceptionBlock)failBlock
        completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self delete:ids];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Undelete a set of sObjects
-(void) performUndelete:(NSArray *)ids
              failBlock:(zkFailWithExceptionBlock)failBlock
          completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self undelete:ids];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Empty a set of sObjects from the recycle bin
-(void) performEmptyRecycleBin:(NSArray *)ids
                     failBlock:(zkFailWithExceptionBlock)failBlock
                 completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self emptyRecycleBin:ids];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Get a set of sObjects
-(void) performRetrieve:(NSString *)fieldList sObjectType:(NSString *)sObjectType ids:(NSArray *)ids
              failBlock:(zkFailWithExceptionBlock)failBlock
          completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self retrieve:fieldList sObjectType:sObjectType  ids:ids];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Submit an entity to a workflow process or process a workitem
-(void) performProcess:(NSArray *)actions
             failBlock:(zkFailWithExceptionBlock)failBlock
         completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self process:actions];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// convert a set of leads
-(void) performConvertLead:(NSArray *)leadConverts
                 failBlock:(zkFailWithExceptionBlock)failBlock
             completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self convertLead:leadConverts];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Logout the current user, invalidating the current session.
-(void) performLogoutWithFailBlock:(zkFailWithExceptionBlock)failBlock
        completeBlock:(zkCompleteVoidBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			[self logout];
			return nil;
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock();
		}];
}

// Logs out and invalidates session ids
-(void) performInvalidateSessions:(NSArray *)sessionIds
                        failBlock:(zkFailWithExceptionBlock)failBlock
                    completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self invalidateSessions:sessionIds];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Get the IDs for deleted sObjects
-(void) performGetDeleted:(NSString *)sObjectType startDate:(NSDate *)startDate endDate:(NSDate *)endDate
                failBlock:(zkFailWithExceptionBlock)failBlock
            completeBlock:(zkCompleteGetDeletedResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self getDeleted:sObjectType startDate:startDate  endDate:endDate];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKGetDeletedResult *)r);
		}];
}

// Get the IDs for updated sObjects
-(void) performGetUpdated:(NSString *)sObjectType startDate:(NSDate *)startDate endDate:(NSDate *)endDate
                failBlock:(zkFailWithExceptionBlock)failBlock
            completeBlock:(zkCompleteGetUpdatedResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self getUpdated:sObjectType startDate:startDate  endDate:endDate];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKGetUpdatedResult *)r);
		}];
}

// Create a Query Cursor
-(void) performQuery:(NSString *)queryString
           failBlock:(zkFailWithExceptionBlock)failBlock
       completeBlock:(zkCompleteQueryResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self query:queryString];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKQueryResult *)r);
		}];
}

// Create a Query Cursor, including deleted sObjects
-(void) performQueryAll:(NSString *)queryString
              failBlock:(zkFailWithExceptionBlock)failBlock
          completeBlock:(zkCompleteQueryResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self queryAll:queryString];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKQueryResult *)r);
		}];
}

// Gets the next batch of sObjects from a query
-(void) performQueryMore:(NSString *)queryLocator
               failBlock:(zkFailWithExceptionBlock)failBlock
           completeBlock:(zkCompleteQueryResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self queryMore:queryLocator];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKQueryResult *)r);
		}];
}

// Search for sObjects
-(void) performSearch:(NSString *)searchString
            failBlock:(zkFailWithExceptionBlock)failBlock
        completeBlock:(zkCompleteSearchResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self search:searchString];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKSearchResult *)r);
		}];
}

// Gets server timestamp
-(void) performGetServerTimestampWithFailBlock:(zkFailWithExceptionBlock)failBlock
                    completeBlock:(zkCompleteGetServerTimestampResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self getServerTimestamp];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKGetServerTimestampResult *)r);
		}];
}

// Set a user's password
-(void) performSetPassword:(NSString *)userId password:(NSString *)password
                 failBlock:(zkFailWithExceptionBlock)failBlock
             completeBlock:(zkCompleteSetPasswordResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self setPassword:userId password:password];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKSetPasswordResult *)r);
		}];
}

// Reset a user's password
-(void) performResetPassword:(NSString *)userId
                   failBlock:(zkFailWithExceptionBlock)failBlock
               completeBlock:(zkCompleteResetPasswordResultBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self resetPassword:userId];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKResetPasswordResult *)r);
		}];
}

// Returns standard information relevant to the current user
-(void) performGetUserInfoWithFailBlock:(zkFailWithExceptionBlock)failBlock
             completeBlock:(zkCompleteUserInfoBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self getUserInfo];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((ZKUserInfo *)r);
		}];
}

// Send existing draft EmailMessage
-(void) performSendEmailMessage:(NSArray *)ids
                      failBlock:(zkFailWithExceptionBlock)failBlock
                  completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self sendEmailMessage:ids];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Send outbound email
-(void) performSendEmail:(NSArray *)messages
               failBlock:(zkFailWithExceptionBlock)failBlock
           completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self sendEmail:messages];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Perform a series of predefined actions such as quick create or log a task
-(void) performPerformQuickActions:(NSArray *)quickActions
                         failBlock:(zkFailWithExceptionBlock)failBlock
                     completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self performQuickActions:quickActions];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe the details of a series of quick actions
-(void) performDescribeQuickActions:(NSArray *)quickActions
                          failBlock:(zkFailWithExceptionBlock)failBlock
                      completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeQuickActions:quickActions];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

// Describe the details of a series of quick actions available for the given contextType
-(void) performDescribeAvailableQuickActions:(NSString *)contextType
                                   failBlock:(zkFailWithExceptionBlock)failBlock
                               completeBlock:(zkCompleteArrayBlock)completeBlock {

	[self performRequest:^NSObject *(void) {
			return [self describeAvailableQuickActions:contextType];
		}
		    failBlock:failBlock
		completeBlock:^(NSObject *r) {
			if (completeBlock) completeBlock((NSArray *)r);
		}];
}

@end
