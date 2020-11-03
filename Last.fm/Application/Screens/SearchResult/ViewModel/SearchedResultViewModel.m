//
//  SearchedResultViewModel.m
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

#import "SearchedResultViewModel.h"

@implementation SearchedResultViewModel

- (void)parseSongsData:(NSString *)queryString aSimpleHandler:(void (^ _Nullable)(NSError * _Nullable))handler {
    self.serviceManager = [[ServiceManager alloc] init];
    self.rootURL = @"https://ws.audioscrobbler.com/2.0/";
    
    self.paradic = @[@[@"api_key", @"1d7f7a0a7bb5a1bd972a6d108a76cc9a"], @[@"method", @"track.search"], @[@"format", @"json"], @[@"track", queryString]];
    
    self.validSongList = [[NSMutableArray alloc] init];
    
    [self.serviceManager fetchData:self.rootURL withParameter:self.paradic aSimpleHandler:^(NSData *data, NSError *error) {
        if (data == nil || error != nil) {
            return;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json[@"results"] isKindOfClass:[NSDictionary class]]) {
                if ([json[@"results"][@"trackmatches"] isKindOfClass:[NSDictionary class]]) {
                    if ([json[@"results"][@"trackmatches"][@"track"] isKindOfClass:[NSArray class]]) {
                        
                        for (NSDictionary *element in json[@"results"][@"trackmatches"][@"track"]) {
                            if ([element isKindOfClass:[NSDictionary class]]) {
                                if (element[@"name"] != nil && element[@"artist"] != nil && element[@"listeners"] != nil) {
                                    if (![element[@"image"][3][@"#text"]  isEqual: @""]) {
                                        NSString *headShotString = element[@"image"][0][@"#text"];
                                        NSURL *headShotURL = [[NSURL alloc] initWithString:headShotString];
                                        NSData *headShotData = [NSData dataWithContentsOfURL:headShotURL];
                                        UIImage *headShotImage = [UIImage imageWithData:headShotData];
                                        ValidSongResult *validSong = [[ValidSongResult alloc] initWithName:element[@"name"] artist:element[@"artist"] listeners:element[@"listeners"] image:headShotImage];
                                        [self.validSongList addObject:validSong];
                                    } else {
                                        UIImage *sampleImage = [UIImage imageNamed:@"unfetchedImage"];
                                        ValidSongResult *validSong = [[ValidSongResult alloc] initWithName:element[@"name"] artist:element[@"artist"] listeners:element[@"listeners"] image:sampleImage];
                                        [self.validSongList addObject:validSong];
                                    }
                                }
                            }
                        }
                        handler(nil);
                    } else { handler(error); }
                } else { handler(error); }
            } else { handler(error); }
        } else { handler(error); }
        NSLog(@"");
    }];
}

- (void)parseAlbumsData:(NSString *)queryString aSimpleHandler:(void (^)(NSError * _Nullable))handler {
    self.serviceManagerAlbumUse = [[ServiceManager alloc] init];
    self.rootURL = @"https://ws.audioscrobbler.com/2.0/";
    self.paradic = @[@[@"api_key", @"1d7f7a0a7bb5a1bd972a6d108a76cc9a"], @[@"method", @"album.search"], @[@"format", @"json"], @[@"album", queryString]];
    self.validAlbumList = [[NSMutableArray alloc] init];

    [self.serviceManagerAlbumUse fetchData:self.rootURL withParameter:self.paradic aSimpleHandler:^(NSData *data, NSError *error) {
        if (data == nil || error != nil) {
            return;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json[@"results"] isKindOfClass:[NSDictionary class]]) {
                if ([json[@"results"][@"albummatches"] isKindOfClass:[NSDictionary class]]) {
                    if ([json[@"results"][@"albummatches"][@"album"] isKindOfClass:[NSArray class]]) {
                        
                        for (NSDictionary *element in json[@"results"][@"albummatches"][@"album"]) {
                            if ([element isKindOfClass:[NSDictionary class]]) {
                                if (element[@"name"] != nil && element[@"artist"] != nil) {
                                    if (![element[@"image"][3][@"#text"]  isEqual: @""]) {
                                        NSString *headShotString = element[@"image"][3][@"#text"];
                                        NSURL *headShotURL = [[NSURL alloc] initWithString:headShotString];
                                        NSData *headShotData = [NSData dataWithContentsOfURL:headShotURL];
                                        UIImage *headShotImage = [UIImage imageWithData:headShotData];
                                        ValidAlbumResult *singleAlbum = [[ValidAlbumResult alloc] initWithName:element[@"name"] artist:element[@"artist"] backUpString:@"" image:headShotImage];
                                        [self.validAlbumList addObject:singleAlbum];
                                    } else {
                                        UIImage *sampleImage = [UIImage imageNamed:@"unfetchedImage"];
                                        ValidAlbumResult *singleAlbum = [[ValidAlbumResult alloc] initWithName:element[@"name"] artist:element[@"artist"] backUpString:@"" image:sampleImage];
                                        [self.validAlbumList addObject:singleAlbum];
                                    }
                                }
                            }
                        }
                        handler(nil);
                        return;
                    } else { handler(error); return; }
                } else { handler(error); return; }
            } else { handler(error); return; }
        } else { handler(error); return; }
    }];    
}

@end
