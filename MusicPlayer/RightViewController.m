//
//  RightViewController.m
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-20.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import "RightViewController.h"
#import "MusicViewController.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.semiTableView.alpha = 0.6f;
    self.semiTitleLabel.alpha = 0.6f;
//    for (int i = 0; i < 100; i++) {
//        [self.dateSourceArray addObject:[NSString stringWithFormat:@"SemiData%d", i]];
        self.dateSourceArray = self.myMusic.musicArray;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
//    cell.backgroundColor = [UIColor blackColor];
    Music *music = [self.dateSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = music.name;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;//该表格选中后没有颜色
    
    cell.textLabel.textColor = [UIColor blackColor];
//    cell.textLabel.backgroundColor = [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myMusic playTable:indexPath.row];
}
@end
