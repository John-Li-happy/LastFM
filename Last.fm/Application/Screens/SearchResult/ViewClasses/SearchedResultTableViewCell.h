//
//  SearchedResultTableViewCell.h
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SearchedResultTableViewCell:UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *listenerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headShotImageView;

- (void)configureCell:(NSString *)title withArtist:(NSString *)artist withListener:(NSString *)listener withHeadShot:(UIImage *)headShot;
@end
