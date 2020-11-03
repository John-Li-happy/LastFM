//
//  SearchedResultViewController.m
//  Last.fm
//
//  Created by Zhaoyang Li on 9/30/20.
//  Copyright © 2020  Prakash. All rights reserved.
//

#import "SearchedResultViewController.h"
#import <Last_fm-Swift.h>

@interface SearchedResultViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *songAlbumControl;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) SearchedResultViewModel *searchedResultViewModel;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;

@end

@implementation SearchedResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSettings];
    [self delegateLoader];
    [self songDataFetch];
    [self albumDataFetch];
}

- (void)initialSettings {
    //UIsettings
    self.tableView.rowHeight = 80;
    self.segmentControlStatus = 0;
    self.loadingLabel.hidden = NO;
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    //Loading Timer
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(nodataShown) userInfo:nil repeats:YES];
    //propertyies setting
    self.searchedResultViewModel = [[SearchedResultViewModel alloc] init];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(enableRotation) name:@"ChannalMusicPlayerDisAppeared" object:nil];
    
    // blurred view settings
    self.blurEffectView = [[UIVisualEffectView alloc] init];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.blurEffectView.frame = self.view.bounds;
    self.blurEffectView.layer.zPosition = 50;
    self.blurEffectView.tag = 100;
    self.blurEffectView.userInteractionEnabled = YES;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(blurredViewRemove) name:@"ChannalBlurView" object:nil];
}

- (void)nodataShown {
    if (self.tableView.visibleCells.count == 0) {
        self.loadingLabel.hidden = NO;
    } else {
        self.loadingLabel.hidden = YES;
    }
}

-(void)delegateLoader {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

//MARK: - Actions Handler
- (IBAction)songAlbumControlTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.segmentControlStatus = 0;
        [self tableReloadData];
    } else {
        self.segmentControlStatus = 1;
        [self tableReloadData];
    }
}

- (void)songDataFetch {
    [self.searchedResultViewModel parseSongsData:self.receivedString aSimpleHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            return;
        }
        [self tableReloadData];
    }];
}

- (void)albumDataFetch {
    [self.searchedResultViewModel parseAlbumsData:self.receivedString aSimpleHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            return;
        }
    }];
}

- (void)tableReloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

//MARK: - TableView Related
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControlStatus == 0) {
        return [self.searchedResultViewModel.validSongList count];
    } else {
        return [self.searchedResultViewModel.validAlbumList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * searchedResultTableViewCellID = @"SearchedResultTableViewCell";
    SearchedResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchedResultTableViewCellID];
    if (self.segmentControlStatus == 0) {
        ValidSongResult *validSong = self.searchedResultViewModel.validSongList[indexPath.row];
        [cell configureCell:validSong.name withArtist:validSong.artist withListener:validSong.listeners withHeadShot:validSong.image];
        return cell;
    } else {
        ValidAlbumResult *validAlbum = self.searchedResultViewModel.validAlbumList[indexPath.row];
        [cell configureCell:validAlbum.name withArtist:validAlbum.artist withListener:validAlbum.backUpString withHeadShot:validAlbum.image];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if (self.segmentControlStatus == 0) {
        MusicPlayerViewController *playerVC = [storyBoard instantiateViewControllerWithIdentifier:@"MusicPlayeViewController"];
        NSMutableArray<ImportedPlayingSong *> *importingPlayingSong = [[NSMutableArray alloc] init];
        for (ValidSongResult *element in self.searchedResultViewModel.validSongList) {
            NSString *songName = element.name;
            NSString *singerName = element.artist;
            ImportedPlayingSong *singleSong = [[ImportedPlayingSong alloc] initWithSongName:songName  singerName:singerName];
            [importingPlayingSong addObject:singleSong];
        }
        
        playerVC.receivedIndex = indexPath.row;
        playerVC.receivedSongList = importingPlayingSong;
        UINavigationController *newNavC = [[UINavigationController alloc] initWithRootViewController:playerVC];
        [self disableRotation];
        [self presentViewController:newNavC animated:YES completion:nil];
        [self addBlurredView];
    } else {
        AlbumDetailViewController *albumDetailVC = [storyBoard instantiateViewControllerWithIdentifier:@"AlbumDetailViewController"];
        albumDetailVC.receivedAlbumName = self.searchedResultViewModel.validAlbumList[indexPath.row].name;
        albumDetailVC.receivedSingerName = self.searchedResultViewModel.validAlbumList[indexPath.row].artist;
        [self.navigationController pushViewController:albumDetailVC animated:YES];
    }
}

- (void)blurredViewRemove {
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == 100) {
            [subView removeFromSuperview];
        }
    }
}

- (void)addBlurredView {
    [self.view addSubview:self.blurEffectView];
}

- (void)disableRotation {
    UITabBarController *tabbarController = self.tabBarController;
    if ([tabbarController isKindOfClass:[MainTabBarController class]]) {
        MainTabBarController *selfTabBarController = tabbarController;
        [selfTabBarController setObserver];
    NSDictionary *storeIDDic = @{@"id": @NO};
    [NSNotificationCenter.defaultCenter postNotificationName:@"ChannalNCRotate" object:nil userInfo:storeIDDic];
    }
}

- (void)enableRotation {
    UITabBarController *tabbarController = self.tabBarController;
    if ([tabbarController isKindOfClass:[MainTabBarController class]]) {
        MainTabBarController *selfTabBarController = tabbarController;
        [selfTabBarController setObserver];
    NSDictionary *storeIDDic = @{@"id": @YES};
    [NSNotificationCenter.defaultCenter postNotificationName:@"ChannalNCRotate" object:nil userInfo:storeIDDic];
    }
}
@end
