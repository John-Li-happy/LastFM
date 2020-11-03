//
//  ServiceManager.m
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceManager.h"

@implementation ServiceManager

//- (instancetype)serviceManager {
//    static ServiceManager *serviceManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^ {
//        serviceManager = [[ServiceManager alloc] init];
//    });
//    return serviceManager;
//}
//
//- (instancetype)init {
//    self = [super init];
//    return self;
//}

- (void)fetchData:(NSString *)rootUrl withParameter:(NSArray *)parameters aSimpleHandler:(void (^)(NSData *, NSError *))handler {
    
    NSURL *url = [[NSURL alloc] initWithString:rootUrl];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableArray *queryItems = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *element in parameters) {
        NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:element.firstObject value:element[1]];
        [queryItems addObject:item];
    }
    [components setQueryItems:queryItems];
    NSURL *completeURL = components.URL;
    
    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithURL:completeURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil || data == nil || response == nil) {
            handler(nil, error);
            return;
        }
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 299) {
                handler(data, nil);
                return;
            }
        }
        handler(nil, error);
        return;
    }];
    [task resume];
}

@end
