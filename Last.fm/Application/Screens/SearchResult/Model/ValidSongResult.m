//
//  ValidSongResults.m
//  MovieOC
//
//  Created by Zhaoyang Li on 10/1/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidSongResult.h"

@implementation ValidSongResult

-(instancetype)initWithName:(NSString *)name artist:(NSString *)artist listeners:(NSString *)listeners image:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.artist = artist;
        self.listeners = listeners;
        self.image = image;
    }
    
    return self;
}

@end
