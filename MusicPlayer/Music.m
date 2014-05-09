//
//  Music.m
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-19.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import "Music.h"

@implementation Music
@synthesize name, type;

- (id)initWithName:(NSString *)_name andType:(NSString *)_type {
    if (self = [super init]) {
        self.name = _name;
        self.type = _type;
    }
    return self;
}

@end
