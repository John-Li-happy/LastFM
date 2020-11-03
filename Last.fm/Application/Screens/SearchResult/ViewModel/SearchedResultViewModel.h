//
//  SearchedResultViewModel.h
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

#import "ServiceManager.h"
#import "ValidSongResult.h"
#import "ValidAlbumResult.h"
#import <UIKit/UIKit.h>

@interface SearchedResultViewModel:NSObject

@property (strong, nonatomic, nullable) ServiceManager *serviceManager;
@property (strong, nonatomic, nullable) ServiceManager *serviceManagerAlbumUse;
@property (strong, nonatomic, nonnull) NSString *rootURL;
@property (strong, nonatomic, nonnull) NSArray *paradic;
@property (nonnull, strong, nonatomic) NSMutableArray<ValidSongResult *> *validSongList;
@property (nonnull, strong, nonatomic) NSMutableArray<ValidAlbumResult *> *validAlbumList;

- (void)parseSongsData:(NSString *_Nonnull)queryString aSimpleHandler:(void (^_Nullable)(NSError *_Nullable))handler;
- (void)parseAlbumsData:(NSString *_Nonnull)queryString aSimpleHandler:(void (^_Nullable)(NSError *_Nullable))handler;

@end
