//
//  SearchedResultViewController.h
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

#import "SearchedResultTableViewCell.h"
#import "SearchedResultViewModel.h"
#import "Last.fm-Bridging-Header.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SkeletonView-Swift.h>
@import SkeletonView;

@interface SearchedResultViewController:UIViewController

@property (assign, nonatomic) NSString *receivedString;
@property (assign, nonatomic) BOOL testValue;
@property (assign, nonatomic) NSInteger segmentControlStatus;

@end
