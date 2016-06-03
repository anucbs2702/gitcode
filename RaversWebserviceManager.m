//
//  WSWebserviceManager.m
//  WifiConnector
//
//  Created by mac on 4/25/15.
//  Copyright (c) 2015 WifiConnector. All rights reserved.
//

#import "RaversWebserviceManager.h"
#import "RCommonClass.h"

@implementation RaversWebserviceManager

static RaversWebserviceManager *wsManger;


- (id)init{
    [self trackInternetConnection];
    return self;
}

+ (RaversWebserviceManager *) sharedInstance {
    if (!wsManger) {
        wsManger = [[RaversWebserviceManager alloc] init];
    }
    return wsManger;
}

-(void)serviceRequestWithParameter:(NSMutableDictionary *)parameters

                        methodName:(NSString *)methodName
                      isShowLoader:(BOOL)isShowLoader
            completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock
           completionBlockFailiure:(void (^)(NSError *error))aFailBlock
{
    
    if ([methodName isEqualToString:WEBSERVICE_LOGIN] || [methodName isEqualToString:WEBSERVICE_UPDATE_PROFILE]) {
        
    }
    if ([RCommonClass checkNullAndEmptyString:[AppDelegate getAppdelegateInstance].deviceToken]) {
        
        [parameters setValue:[AppDelegate getAppdelegateInstance].deviceToken forKey:K_DEVICE_TOKEN];
    }
    else
    {
        [parameters setValue:@"1211212121" forKey:K_DEVICE_TOKEN];
    
    }
    
    if([self connected])
    {
        if (isShowLoader) {
            [self showLoader];

        }
//        if (![methodName isEqualToString:WEBSERVICE_UPDATE_LOCATION]) {
//        }
//       
       
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
       // manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        
        [manager.requestSerializer setTimeoutInterval:30];
        //manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
        
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSString *strServiceUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,methodName];
        NSLog(@"URL %@", strServiceUrl);
        NSLog(@"Params in JSON: %@", parameters);
//        if(PRINTLOG)
//        {
//            NSLog(@"URL %@", strServiceUrl);
//            NSLog(@"Params in JSON: %@", parameters);
//            
//        }
        [manager POST:strServiceUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (isShowLoader) {
                 [self hideLoader];
             }

             //if(PRINTLOG)
             //NSLog(@"JSON: %@", responseObject);
             if([self connected])
             {
                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                     //NSDictionary *jsonData =[[NSDictionary alloc] initWithDictionary:responseObject];
                     succesBlock (responseObject);
                 }
                 
                 //[self.delegate getServiceResponse:responseObject];
             }
             else
             {
                 //[FKCommonClass showToastOnWindowWithTitle:@"Network connection appears to offline."];
                 [self hideLoader];
                 aFailBlock (operation.error);
             }
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self hideLoader];
             NSLog(@"Error: %@", error);
             //[BKCommonClass showAlert:[error localizedDescription]];
             aFailBlock (error);
         }];
    }
    else
    {
        [self hideLoader];
        //NetworkAvailablity
        
         //[FKCommonClass showToastOnWindowWithTitle:@"Network connection appears to offline."];
        
        //Custom NSError
        //NetworkConnectionLost
        //CheckNetworkConnection
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:@"NetworkAvailablity",
                                   NSLocalizedFailureReasonErrorKey:@"NetworkConnectionLost",
                                   NSLocalizedRecoverySuggestionErrorKey:@"CheckNetworkConnection"
                                   };
        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:-1005 userInfo:userInfo];
        aFailBlock (error);
    }
}

-(void)serviceRequestWithGetParameter:(NSMutableDictionary *)getParams
                        postParameter:(NSMutableDictionary *)postParams
                           methodName:(NSString *)methodName
               completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock
              completionBlockFailiure:(void (^)(NSError *error))aFailBlock;
{
    NSLog(@"%d",[self connected]);
    if([self connected])
    {
        [self showLoader];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //[manager.requestSerializer setTimeoutInterval:50];
        //manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
        
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSString *strBaseUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,methodName];
        NSMutableString *strServiceUrl=[[NSMutableString alloc] initWithString:strBaseUrl];
        if(getParams)
        {
            //&securityUserName=39c&securityPassword=cdn123&device_id=1211212121&device_type=IOS&lang=zh
            NSArray *arrKeys=[getParams allKeys];
            for (int i=0; i<[arrKeys count]; i++) {
                [strServiceUrl appendFormat:@"&%@=%@",[arrKeys objectAtIndex:i],[getParams valueForKey:[arrKeys objectAtIndex:i]]];
            }
        }
        
        
//        if(PRINTLOG)
//        {
//            NSLog(@"URL %@", strServiceUrl);
//            NSLog(@"Post Params in JSON: %@", postParams);
//            NSLog(@"Get Params in JSON: %@", getParams);
//        }
        [manager POST:strServiceUrl parameters:postParams success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self hideLoader];
             //if(PRINTLOG)
             //NSLog(@"JSON: %@", responseObject);
             NSLog(@"%d",[self connected]);
             if([self connected])
             {
                 //NSDictionary *jsonData =[[NSDictionary alloc] initWithDictionary:responseObject];
                 succesBlock (responseObject);
                 //[self.delegate getServiceResponse:responseObject];
             }
             else
             {
                 //[BKCommonClass showToastWithMessage:TEXT(@"NetworkAvailablity")];
                 aFailBlock (operation.error);
             }
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self hideLoader];
             NSLog(@"Error: %@", error);
             //[BKCommonClass showAlert:[error localizedDescription]];
             aFailBlock (error);
         }];
    }
    else
    {
        [self hideLoader];
      //  [BKCommonClass showToastWithMessage:TEXT(@"NetworkAvailablity")];
        
        //Custom NSError
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:@"NetworkAvailablity",
                                   NSLocalizedFailureReasonErrorKey:@"NetworkConnectionLost",
                                   NSLocalizedRecoverySuggestionErrorKey:@"CheckNetworkConnection"
                                   };
        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:-1005 userInfo:userInfo];
        aFailBlock (error);
    }
}


/**
 *  Method for LOGIN.
 *
 *  @param UrlString  WEBSERVICE URL
 *  @param parameter  REGISTRATION PARAMETER
 *  @param methodType METHOD DISCRIPTION
 *  @param consumer   BLOCK (TAKING RESPONSE)
 */
-(void)doPerfromLogin:(NSString *)UrlString andParam:(NSMutableDictionary *)parameter andMethod:(NSString *)methodType completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock completionBlockFailiure:(void (^)(NSError *error))aFailBlock;
{
     [self showLoader];
    [self doPerfromWebserviceCall:UrlString methodType:methodType andParameter:parameter andBaseUrl:BASE_URL completionBlockSuccess:^(NSMutableDictionary *response) {
        [self hideLoader];
         succesBlock (response);
        
    } completionBlockFailiure:^(NSError *error) {
        
         [self hideLoader];
        aFailBlock(error);
    }];
//    [self doPerfromWebserviceCall:UrlString methodType:methodType andParameter:parameter andBaseUrl:BASE_URL consumer:^(NSDictionary * responseDict, NSError * error) {
//        if (error) {
//            consumer (nil,error);
//        }
//        else{
//            consumer (responseDict,nil);
//        }
//    }];
}
/**
 *  Method for performing webservice calling in view.
 *
 *  @param webserviceUrl    webserviceUrl
 *  @param methodType       Method type (post and get)
 *  @param requestParameter Request parameter
 *  @param baseUrl          base url
 *  @param consumer         block for taking response.
 */
-(void)doPerfromWebserviceCall:(NSString*)webserviceUrl methodType:(NSString *)methodType andParameter:(NSMutableDictionary *)requestParameter andBaseUrl:(NSString *)baseUrl completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock completionBlockFailiure:(void (^)(NSError *error))aFailBlock;
{
    
   // [requestParameter setValue:@"1211212121" forKey:param_device_id];
   // [requestParameter setValue:@"iOS" forKey:param_device_type_id];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",baseUrl,webserviceUrl];
    NSError * error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParameter
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding],@"RequestString", nil];
    //    NSData *finalJsonData = [NSJSONSerialization dataWithJSONObject:dict
    //                                                       options:NSJSONWritingPrettyPrinted
    //                                                         error:&error];
    //    [request setHTTPBody:finalJsonData];
    
    NSDictionary * requestDict = [[NSDictionary alloc] initWithObjectsAndKeys:dict,@"request", nil];
    NSData *finalRequestJsonData = [NSJSONSerialization dataWithJSONObject:requestDict
                                                                   options:0
                                                                     error:&error];
    [request setHTTPBody:finalRequestJsonData];
    [request setTimeoutInterval:90];
    
    NSLog(@"Request string is %@",[[NSString alloc] initWithData:finalRequestJsonData encoding:NSUTF8StringEncoding]);
    
    [request setValue:@"text/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:methodType];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode = [operation.response statusCode];
        if (statusCode==200) {
            if (responseObject!=nil) {
                NSMutableDictionary *json=[NSJSONSerialization
                                    JSONObjectWithData:responseObject
                                    options:NSJSONReadingMutableLeaves
                                    error:nil];
                
                succesBlock (json);
            }
            else{
                aFailBlock (error);
            }
        }
        // 3
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        aFailBlock (error);
    }];
    // 5
    [operation start];
}

//Monitors internet connection and excutes block when ever network changes
- (void)trackInternetConnection
{
    __weak typeof(self) weakSelf = self;
    self.afReachability = [AFNetworkReachabilityManager managerForDomain:@"www.google.com"];
    [self.afReachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status < AFNetworkReachabilityStatusReachableViaWWAN)
        {
            //[BKCommonClass showToastWithMessage:TEXT(@"NetworkAvailablity")];
            [weakSelf hideLoader];
        }
        else
            NSLog(@"Network available.");
    }];
    [self.afReachability startMonitoring];
}

//Returns YES for network available otherwise returns NO
- (BOOL)connected {
    //return [AFNetworkReachabilityManager sharedManager].reachable;
    return self.afReachability.reachable;
}

/*
 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
 // Do something...
 dispatch_async(dispatch_get_main_queue(), ^{
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 });
 });
 */

-(void)showLoader
{
    [RCommonClass showProgressInWindow];
}

-(void)hideLoader
{
    [RCommonClass hideProgressHud];
}

- (NSString *)storyboardName
{
    // fetch the appropriate storyboard name depending on platform
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return @"Main";
    else
        return @"MainStoryboard_iPad";
}

-(void)doLoggedOutFromCurrentDevice:(NSDictionary *)dictInfo
{
    
}

-(void)showToastOnWindowWithTitle:(NSString *)title
{
    [[AppDelegate getAppdelegateInstance].window.rootViewController.view makeToast:title];
}

-(void)doUpdateUserCurrentLocationOnServerWithLocation:(CLLocationCoordinate2D)locationCord
{
    NSMutableDictionary *dictParams=[[NSMutableDictionary alloc]init];
    NSString *locationMap=[NSString stringWithFormat:@"%f,%f",locationCord.latitude,locationCord.longitude];
    [dictParams setValue:[RCommonClass getUserId] forKey:K_USER_ID];
    [dictParams setValue:locationMap forKey:K_CURRENT_GEOLOCATION];
    NSLog(@"Update Location Service Params %@",dictParams);
    [self serviceRequestWithParameter:dictParams methodName:WEBSERVICE_UPDATE_LOCATION  isShowLoader:NO completionBlockSuccess:^(NSMutableDictionary *responseObject) {
        NSLog(@"Response of update location is %@",responseObject);
    } completionBlockFailiure:^(NSError *error) {
       [[RaversWebserviceManager sharedInstance]showToastOnWindowWithTitle:[error localizedDescription]];  
    }];
}
@end
