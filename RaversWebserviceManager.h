//
//  RaversWebserviceManager.h
//
//  Created by mac on 4/25/15.
//  Copyright (c) 2015 WifiConnector. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface RaversWebserviceManager : NSObject
@property (strong, nonatomic) AFNetworkReachabilityManager *afReachability;
+ (RaversWebserviceManager *) sharedInstance;

-(void)serviceRequestWithParameter:(NSMutableDictionary *)parameters

                        methodName:(NSString *)methodName
                      isShowLoader:(BOOL)isShowLoader
            completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock
           completionBlockFailiure:(void (^)(NSError *error))aFailBlock;


/*-(void)serviceRequestWithParameter:(NSMutableDictionary *)parameters
                        methodName:(NSString *)methodName
            completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock
           completionBlockFailiure:(void (^)(NSError *error))aFailBlock;*/

-(void)serviceRequestWithGetParameter:(NSMutableDictionary *)getParams
                        postParameter:(NSMutableDictionary *)postParams
                           methodName:(NSString *)methodName
               completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock
              completionBlockFailiure:(void (^)(NSError *error))aFailBlock;

-(void)doPerfromLogin:(NSString *)UrlString andParam:(NSMutableDictionary *)parameter andMethod:(NSString *)methodType completionBlockSuccess:(void (^)(NSMutableDictionary *))succesBlock completionBlockFailiure:(void (^)(NSError *error))aFailBlock;

-(void)doUpdateUserCurrentLocationOnServerWithLocation:(CLLocationCoordinate2D)locationCord;

-(void)showToastOnWindowWithTitle:(NSString *)title;
-(void)showLoader;
-(void)hideLoader;

- (BOOL)connected;
@end
