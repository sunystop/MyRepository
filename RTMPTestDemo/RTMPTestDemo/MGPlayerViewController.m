//
//  MGPlayerViewController.m
//  RTMPTestDemo
//
//  Created by 苏晗 on 2017/8/11.
//  Copyright © 2017年 MapGoo. All rights reserved.
//

#import "MGPlayerViewController.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import <Masonry.h>
#import "UIView+Toast.h"

@interface MGPlayerViewController ()
@property (nonatomic, copy) NSString *rtmpURL;
@property (nonatomic, strong) KSYMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MGPlayerViewController

- (void)dealloc
{
    [self removeObserver];
}

- (instancetype)initWithRTMPURL:(NSString *)rtmpURL
{
    if (self = [super init])
    {
        _rtmpURL = rtmpURL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupObservers];
    
    [self.activityIndicatorView startAnimating];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"image_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(30);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    _moviePlayerController = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.rtmpURL]];
    [_moviePlayerController.view setFrame:self.view.bounds];
    [self.view addSubview:_moviePlayerController.view];
    
    _moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _moviePlayerController.shouldAutoplay = YES;
    _moviePlayerController.shouldEnableVideoPostProcessing = YES;
    _moviePlayerController.scalingMode = MPMovieScalingModeNone;
    _moviePlayerController.videoDecoderMode = MPMovieVideoDecoderMode_AUTO;
    [_moviePlayerController prepareToPlay];
    
    [_moviePlayerController setLogBlock:^(NSString *logJson) {
        
        NSLog(@"返回信息: %@", logJson);
        
    }];
    
    
    [self.view bringSubviewToFront:backButton];
}

- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerSuggestReloadNotification)
                                              object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStatusNotification)
                                              object:_moviePlayerController];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMovieNaturalSizeAvailableNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerFirstVideoFrameRenderedNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerFirstAudioFrameRenderedNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerSuggestReloadNotification
                                                 object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStatusNotification
                                                 object:_moviePlayerController];
}

- (void)handlePlayerNotify:(NSNotification *)notify
{
    if (!_moviePlayerController)
    {
        return;
    }
    
    // 错误提示
    [self.view makeToast:[self errorWithCodeString:notify.name] duration:2.0f position:@"bottom"];
    
    //
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification == notify.name)
    {
        // 播放器完成对视频文件的初始化时发送此通知
        NSLog(@"播放器完成对视频文件的初始化时发送此通知");
        
        [self.activityIndicatorView stopAnimating];
    }
    
    if (MPMoviePlayerPlaybackStateDidChangeNotification == notify.name)
    {
        NSLog(@"------------------------");
        NSLog(@"当前播放器的播放状态: %ld", (long)self.moviePlayerController.playbackState);
        NSLog(@"------------------------");
        
        // 播放状态发生改变时发送此通知
        switch (self.moviePlayerController.playbackState) {
                
            case MPMoviePlaybackStatePlaying:
                NSLog(@"正在播放.");
                [self.activityIndicatorView stopAnimating];
                break;
            case MPMoviePlaybackStatePaused:
                NSLog(@"暂停播放.");
                [self.activityIndicatorView startAnimating];
                [self.view bringSubviewToFront:self.activityIndicatorView];
                break;
            case MPMoviePlaybackStateStopped:
                NSLog(@"停止播放.");
                [self.moviePlayerController play];
                break;
            default:
                NSLog(@"播放状态:%li",self.moviePlayerController.playbackState);
                break;
        }
        
        [self getPlayerState];
    }
    
    if (MPMoviePlayerLoadStateDidChangeNotification == notify.name)
    {
        NSLog(@"当前播放器的加载状态: %ld", (long)self.moviePlayerController.loadState);
        
        if (MPMovieLoadStateStalled & self.moviePlayerController.loadState) {
            NSLog(@"播放器开始缓存");
        }
        if (self.moviePlayerController.bufferEmptyCount &&
            (MPMovieLoadStatePlayable & self.moviePlayerController.loadState ||
             MPMovieLoadStatePlaythroughOK & self.moviePlayerController.loadState)){
                NSLog(@"播放器完成缓存");
                NSString *message = [[NSString alloc]initWithFormat:@"加载, %d - %0.3fs",
                                     (int)self.moviePlayerController.bufferEmptyCount,
                                     self.moviePlayerController.bufferEmptyDuration];
                
                [self.view makeToast:message duration:2.0f position:@"center"];
            }
        
        [self getPlayerState];
        
    }
    
    // 当视频播放结束或用户退出是的回调
    if (MPMoviePlayerPlaybackDidFinishNotification == notify.name)
    {
        NSLog(@"播放器完成状态: %ld", (long)self.moviePlayerController.playbackState);
        NSLog(@"播放器下载流的大小: %f MB", self.moviePlayerController.readSize);
        NSLog(@"缓冲区的检测结果: \n   发起cache的次数: %d, 耗时: %f seconds",
              (int)self.moviePlayerController.bufferEmptyCount,
              self.moviePlayerController.bufferEmptyDuration);
        
        [self getPlayerState];
        
        // 正常播放结束或者因为错误播放失败时发送此通知
        NSDictionary *info = [notify userInfo];
        NSInteger error = [info[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];

        if (error == MPMovieFinishReasonPlaybackEnded)
        {
            // 播放结束
        }
        else if (error == MPMovieFinishReasonPlaybackError)
        {
            // 播放错误
            [self.moviePlayerController reload:[NSURL URLWithString:self.rtmpURL] flush:YES mode:MPMovieReloadMode_Accurate];
        }
        else if (error == MPMovieFinishReasonUserExited)
        {
            // 用户主动退出
            [self.moviePlayerController stop];
        }
    }
    
    if (MPMovieNaturalSizeAvailableNotification == notify.name)
    {
        // 第一次检测出视频的宽高或者播放过程中宽高发生改变时发送此通知
        NSLog(@"视频大小: %.0f-%.0f, rotate:%ld\n", self.moviePlayerController.naturalSize.width, self.moviePlayerController.naturalSize.height, (long)self.moviePlayerController.naturalRotate);
    }
    
    if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
    {
        // 渲染第一帧视频时发送此通知
//        [SVProgressHUD dismiss];
        
//        NSLog(@"渲染第一帧视频时发送此通知");
    }
    
    if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
    {
        // 渲染第一帧音频时发送此通知
    }
    
    if (MPMoviePlayerSuggestReloadNotification == notify.name)
    {
        // 为提升开播速度，播放器在查找文件格式时只检查少量的数据;
        // 如果音视频数据交织情况较差，会导致播放器认为当前码流中只含有视频或者音频数据;
        // 但是在播放过程中，发现实际上存在着未检测到的音频或者视频流，此时播放器会发送此通知
        // 当用户监听到此通知时，请务必调用- (void)reload:(NSURL *)aUrl flush:(bool)flush mode:(MPMovieReloadMode)mode方法，并将mode模式设置为MPMovieReloadMode_Accurate来重新加载码流
    }
    
    if (MPMoviePlayerPlaybackStatusNotification == notify.name)
    {
        // 当播放过程中发生需要上层注意的事件时发送此通知，如实际采用的视频解码方式、解码出现错误等...
        NSLog(@"当播放过程中发生需要上层注意的事件时发送此通知，如实际采用的视频解码方式、解码出现错误等...");
        int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
        if(MPMovieStatusVideoDecodeWrong == status)
            NSLog(@"视频解码错误!\n");
        else if(MPMovieStatusAudioDecodeWrong == status)
            NSLog(@"音频解码错误!\n");
        else if (MPMovieStatusHWCodecUsed == status )
            NSLog(@"采用硬件编解码器\n");
        else if (MPMovieStatusSWCodecUsed == status )
            NSLog(@"采用软件编解码器\n");
        else if(MPMovieStatusDLCodecUsed == status)
            NSLog(@"AVSampleBufferDisplayLayer编解码器使用");
    }
//    if(MPMoviePlayerNetworkStatusChangeNotification == notify.name)
//    {
//        int currStatus = [[[notify userInfo] valueForKey:MPMoviePlayerCurrNetworkStatusUserInfoKey] intValue];
//        int lastStatus = [[[notify userInfo] valueForKey:MPMoviePlayerLastNetworkStatusUserInfoKey] intValue];
//        NSLog(@"network reachable change from %@ to %@\n", [self netStatus2Str:lastStatus], [self netStatus2Str:currStatus]);
//    }
//    if(MPMoviePlayerSeekCompleteNotification == notify.name)
//    {
//        NSLog(@"Seek complete");
//    }
}

#pragma mark - Action
- (void)backButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.view addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

// 旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        
        _activityIndicatorView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma error

- (NSString *)errorWithCodeString:(NSString *)codeString
{
    NSInteger code = [codeString integerValue];
    
    if (code == 1)
    {
        return @"未知的播放器错误";
    }
    else if (code == -1004)
    {
        return @"文件或网络相关操作错误";
    }
    else if (code == -10001)
    {
        return @"不支持的流媒体协议";
    }
    else if (code == -10002)
    {
        return @"DNS解析失败";
    }
    else if (code == -10003)
    {
        return @"创建socket失败";
    }
    else if (code == -10004)
    {
        return @"连接服务器失败";
    }
    else if (code == -10005)
    {
        return @"http请求返回400";
    }
    else if (code == -10006)
    {
        return @"http请求返回401";
    }
    else if (code == -10007)
    {
        return @"http请求返回403";
    }
    else if (code == -10008)
    {
        return @"http请求返回404";
    }
    else if (code == -10009)
    {
        return @"http请求返回4xx";
    }
    else if (code == -10010)
    {
        return @"http请求返回5xx";
    }
    else if (code == -10011)
    {
        return @"无效的媒体数据";
    }
    else if (code == -10012)
    {
        return @"不支持的视频编码类型";
    }
    else if (code == -10013)
    {
        return @"不支持的音频编码类型";
    }
    else if (code == -10014)
    {
        return @"视频解码失败";
    }
    else if (code == -10015)
    {
        return @"音频解码失败";
    }
    else if (code == -10016)
    {
        return @"多次3xx跳转";
    }
    else if (code == -10050)
    {
        return @"无效的url";
    }
    else if (code == -10051)
    {
        return @"网络不通";
    }
    else
    {
        return @"";
    }
    
}

- (void)getPlayerState
{
    // 数据加载状态发生改变时发送此通知
    switch (self.moviePlayerController.loadState)
    {
        case MPMovieLoadStateUnknown:
            NSLog(@"加载情况未知");
            break;
        case MPMovieLoadStatePlayable:
            NSLog(@"加载完成,可以播放");
            break;
        case MPMovieLoadStatePlaythroughOK:
            NSLog(@"加载完成，如果shouldAutoPlay为YES，将自动开始播放");
            break;
        case MPMovieLoadStateStalled:
            NSLog(@"加载中");
            break;
        default:
            break;
    }
}

@end
