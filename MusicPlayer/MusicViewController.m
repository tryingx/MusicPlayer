//
//  MusicViewController.m
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-19.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import "MusicViewController.h"
#import "DXSemiViewControllerCategory.h"


@interface MusicViewController ()

@end
//用静态全局变量来保存这个单例
//static MusicViewController *instance = nil;


@implementation MusicViewController

@synthesize soundSlider, progressSlider, playBtn, circleBtn, currentTimeLabel, totalTimeLabel, musicTableView, lrcTableView, musicArray;

//+ (id)sharemusicArray {
//    if (instance == nil) {
//        instance = [[[self class] alloc] init];
//    }
//    return instance;
//}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isPlay = YES;
    isCircle = YES;
    lrcLineNumber = 0;
    musicTableViewHidden = YES;//初始化隐藏歌曲目录
    musicTableView.hidden = YES;
    
    //初始化要加载的曲目
    [self initDate];
    musicArrayNumber = 0;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[musicArray[musicArrayNumber] name] ofType:@"mp3"]] error:nil];
    currentMusic = musicArray[musicArrayNumber];
    
    //初始化音量和音量进度条
    audioPlayer.volume = 0.5;
    soundSlider.value = audioPlayer.volume;
    [soundSlider setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateNormal];
    [soundSlider setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateHighlighted];
//    soundSlider.hidden = YES;
    
    //初始化歌词词典
    timeArray = [[NSMutableArray alloc] initWithCapacity:10];
    LRCDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    //初始化播放进度条
    [progressSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateNormal];
    [progressSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateHighlighted];
    
    [self initLRC];
    //设置监控 每秒刷新一次时间
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(showTime)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark 载入歌曲数组
- (void)initDate {
    Music *music1 = [[Music alloc] initWithName:@"梁静茹-偶阵雨" andType:@"mp3"];
    Music *music2 = [[Music alloc] initWithName:@"林俊杰-背对背拥抱" andType:@"mp3"];
    Music *music3 = [[Music alloc] initWithName:@"情非得已" andType:@"mp3"];
    Music *music4 = [[Music alloc] initWithName:@"张宇-雨一直下" andType:@"mp3"];
    Music *music5 = [[Music alloc] initWithName:@"张学友-吻别" andType:@"mp3"];
    musicArray = [[NSMutableArray alloc]initWithCapacity:5];
    [musicArray addObject:music1];
    [musicArray addObject:music2];
    [musicArray addObject:music3];
    [musicArray addObject:music4];
    [musicArray addObject:music5];
    
    
    
}
#pragma mark 0.1秒一次更新 播放时间 播放进度条 歌词 歌曲 自动播放下一首
- (void)showTime {
    //动态更新进度条时间
    if ((int)audioPlayer.currentTime % 60 < 10) {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
    } else {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
    }
    //
    if ((int)audioPlayer.duration % 60 < 10) {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)audioPlayer.duration / 60, (int)audioPlayer.duration % 60];
    } else {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.duration / 60, (int)audioPlayer.duration % 60];
    }
    progressSlider.value = audioPlayer.currentTime / audioPlayer.duration;
    
    [self displaySondWord:audioPlayer.currentTime];//调用歌词函数
    
    //如果播放完，调用自动播放下一首
    if (progressSlider.value > 0.999) {
            [self autoPlay];
    }

    //    NSLog(@"%f",audioPlayer.volume);
}

#pragma mark 得到歌词
- (void)initLRC {
    NSString *LRCPath = [[NSBundle mainBundle] pathForResource:[musicArray[musicArrayNumber] name] ofType:@"lrc"];
    NSString *contentStr = [NSString stringWithContentsOfFile:LRCPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"contentStr = %@",contentStr);
    NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [array count]; i++) {
        NSString *linStr = [array objectAtIndex:i];
        NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
        if ([lineArray[0] length] > 8) {
            NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                NSString *lrcStr = [lineArray objectAtIndex:1];
                NSString *timeStr = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                //把时间 和 歌词 加入词典
                [LRCDictionary setObject:lrcStr forKey:timeStr];
                [timeArray addObject:timeStr];//timeArray的count就是行数
            }
        }
    }
}
#pragma mark 动态显示歌词
- (void)displaySondWord:(NSUInteger)time {
    //    NSLog(@"time = %u",time);
    for (int i = 0; i < [timeArray count]; i++) {
        
        NSArray *array = [timeArray[i] componentsSeparatedByString:@":"];//把时间转换成秒
        NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
        if (i == [timeArray count]-1) {
            //求最后一句歌词的时间点
            NSArray *array1 = [timeArray[timeArray.count-1] componentsSeparatedByString:@":"];
            NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
            if (time > currentTime1) {
                [self updateLrcTableView:i];
                break;
            }
        } else {
            //求出第一句的时间点，在第一句显示前的时间内一直加载第一句
            NSArray *array2 = [timeArray[0] componentsSeparatedByString:@":"];
            NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
            if (time < currentTime2) {
                [self updateLrcTableView:0];
//                NSLog(@"马上到第一句");
                break;
            }
            //求出下一步的歌词时间点，然后计算区间
            NSArray *array3 = [timeArray[i+1] componentsSeparatedByString:@":"];
            NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
            if (time >= currentTime && time <= currentTime3) {
                [self updateLrcTableView:i];
                break;
            }
            
        }
    }
}
   
#pragma mark 动态更新歌词表歌词
- (void)updateLrcTableView:(NSUInteger)lineNumber {
//    NSLog(@"lrc = %@", [LRCDictionary objectForKey:[timeArray objectAtIndex:lineNumber]]);
    //重新载入 歌词列表lrcTabView
    lrcLineNumber = lineNumber;
    [lrcTableView reloadData];
    //使被选中的行移到中间
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lineNumber inSection:0];
    [lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    NSLog(@"%i",lineNumber);
}


#pragma mark 播放目前的音乐
- (IBAction)play:(id)sender {
    if (isPlay) {
        [audioPlayer play];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        isPlay = NO;
    } else {
        [audioPlayer pause];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlay = YES;
    }
    audioPlayer.volume = soundSlider.value;//重置音量,(每次播放的默认音量好像是1.0)
}
#pragma mark 上一首
- (IBAction)aboveMusic:(id)sender {
    if (musicArrayNumber == 0) {
        musicArrayNumber = musicArray.count;
    }
    musicArrayNumber --;
    
    [self updatePlayerSetting];
}
#pragma mark 下一首
- (IBAction)nextMusic:(id)sender {
    if (musicArrayNumber == musicArray.count - 1) {
        musicArrayNumber = -1;
    }
    musicArrayNumber ++;
    
    [self updatePlayerSetting];
}
#pragma mark 自动进入下一首
- (void)autoPlay {
    //判断是否允许循环播放
    if (isCircle == YES) {
        if (musicArrayNumber == musicArray.count - 1) {
            musicArrayNumber = -1;
        }
        musicArrayNumber ++;
        
        [self updatePlayerSetting];
    } else {
        [audioPlayer play];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlay = NO;
    }
}
#pragma mark 摇一摇 换歌
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (musicArrayNumber == musicArray.count - 1) {
            musicArrayNumber = -1;
        }
        musicArrayNumber ++;
        
        [self updatePlayerSetting];
    }
}
//更新播放器设置
- (void)updatePlayerSetting {
    //更新播放按钮状态
        [playBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    isPlay = NO;
    
    //更新曲目
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[musicArray[musicArrayNumber] name] ofType:@"mp3"]] error:nil];
    currentMusic = musicArray[musicArrayNumber];
    //更新音量
    audioPlayer.volume = soundSlider.value;
    //重新载入歌词词典
    timeArray = [[NSMutableArray alloc] initWithCapacity:10];
    LRCDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self initLRC];
    
    [audioPlayer play];
}



- (IBAction)progressChange:(id)sender {
    audioPlayer.currentTime = progressSlider.value * audioPlayer.duration;
}

- (IBAction)soundChange:(id)sender {
    audioPlayer.volume = soundSlider.value;
}

- (IBAction)circle:(id)sender {
    if (isCircle) {
        circleBtn.alpha = 0.5;
        isCircle = NO;
    } else {
        circleBtn.alpha = 1.0;
        isCircle = YES;
    }
}

#pragma mark 表视图
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return [musicArray count];
    } else {
        return [timeArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LRCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//该表格选中后没有颜色
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == lrcLineNumber) {
        cell.textLabel.text = LRCDictionary[timeArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    } else {
        cell.textLabel.text = LRCDictionary[timeArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //        cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //        [cell.contentView addSubview:lable];//往列表视图里加 label视图，然后自行布局
    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}
//选中后的响应函数
- (void)playTable:(NSUInteger)tableNumber {
    musicArrayNumber = tableNumber;
    [self updatePlayerSetting];
}
#pragma mark 歌曲目录 按钮
- (IBAction)rightView:(id)sender {
    RightViewController *rightView = [[RightViewController alloc] init];
    rightView.myMusic = self;
    rightView.semiTitleLabel.text = @"";
    self.leftSemiViewController = rightView;
}
@end
