//
//  ServiceManager.h
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceManager:NSObject

//- (instancetype) serviceManager;
- (void)fetchData:(NSString *)rootUrl withParameter:(NSArray *)parameters aSimpleHandler:(void (^)(NSData *, NSError *))handler;

@end
