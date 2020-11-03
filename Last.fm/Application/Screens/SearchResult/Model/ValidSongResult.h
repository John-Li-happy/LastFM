//
//  ValidSongResults.h
//  MovieOC
//
//  Created by Zhaoyang Li on 10/1/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ValidSongResult:NSObject

@property (strong, nonnull, nonatomic) NSString *name;
@property (strong, nonnull, nonatomic) NSString *artist;
@property (strong, nonnull, nonatomic) NSString *listeners;
@property (strong, nonnull, nonatomic) UIImage *image;


- (instancetype _Nonnull )initWithName: (NSString *_Nonnull)name artist:(NSString *_Nonnull)artist listeners:(NSString *_Nonnull)listeners image:(UIImage *_Nonnull)image;

@end
