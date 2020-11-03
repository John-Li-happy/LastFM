//
//  SearchedResultTableViewCell.m
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//
#import "SearchedResultTableViewCell.h"
//#import <Last_fm-Swift.h>

@implementation SearchedResultTableViewCell

- (void)configureCell:(NSString *)title withArtist:(NSString *)artist withListener:(NSString *)listener withHeadShot:(UIImage *)headShot {
    self.titleLabel.text = title;
    self.singerLabel.text = artist;
    self.listenerLabel.text = listener;
    self.headShotImageView.image = headShot;
}

@end
