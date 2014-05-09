//
//  MusicViewController.h
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-19.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Music.h"
#import "RightViewController.h"
#import "DXSemiViewControllerCategory.h"

@interface MusicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AVAudioPlayer *audioPlayer;
    NSMutableArray *musicArray;
    BOOL isPlay;
    BOOL isCircle;
    BOOL musicTableViewHidden;
    float tempVolume;
    Music *currentMusic;
    NSMutableArray *timeArray;
    NSMutableDictionary *LRCDictionary;
    NSUInteger lrcLineNumber;
    NSUInteger musicArrayNumber;
}
@property (nonatomic, strong) NSMutableArray *musicArray;

- (IBAction)aboveMusic:(id)sender;
- (IBAction)nextMusic:(id)sender;

- (IBAction)play:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;


@property (strong, nonatomic) IBOutlet UISlider *progressSlider;
- (IBAction)progressChange:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *soundSlider;
- (IBAction)soundChange:(id)sender;

- (IBAction)circle:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *circleBtn;



@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (strong, nonatomic) IBOutlet UITableView *musicTableView;

@property (strong, nonatomic) IBOutlet UITableView *lrcTableView;
//显示歌曲目录

- (IBAction)rightView:(id)sender;

- (void)playTable:(NSUInteger)tableNumber;
@end
