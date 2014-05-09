//
//  RightViewController.h
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-20.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXSemiTableViewController.h"


@class MusicViewController;

@interface RightViewController : DXSemiTableViewController

@property (weak,nonatomic)  MusicViewController  *myMusic;
@end
