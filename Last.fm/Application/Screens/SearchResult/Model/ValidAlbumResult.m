//
//  ValidAlbumList.m
//  MovieOC
//
//  Created by Zhaoyang Li on 10/1/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidAlbumResult.h"

@implementation ValidAlbumResult

-(instancetype)initWithName:(NSString *)name artist:(NSString *)artist backUpString:(NSString *)backUpString image:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.artist = artist;
        self.backUpString = backUpString;
        self.image = image;
    }
    
    return self;
}

@end
