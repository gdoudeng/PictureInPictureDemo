//
//  ViewController.m
//  PictureInPictureDemo
//
//  Created by linkcircle on 2020/10/14.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>

@interface ViewController ()<AVPictureInPictureControllerDelegate>
@property(strong,nonatomic) AVPictureInPictureController *pipVC;
@property(strong,nonatomic) AVPlayerLayer *playerLayer;
@property(strong,nonatomic) AVPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openAccess];
    [self setupPictureInPicture];
    [self creatBtn];
    // Do any additional setup after loading the view.
}
-(void)openAccess{
    @try {
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
    } @catch (NSException *exception) {
        NSLog(@"AVAudioSession发生错误");
    }
}
-(void)setupPictureInPicture{
    NSURL *urlVideo = [[NSBundle mainBundle] URLForResource:@"v1" withExtension:@"MP4"];
    AVAsset *asset = [AVAsset assetWithURL:urlVideo];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.frame;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    // 添加自定义layer
//    CALayer *pulseLayer_ = [CALayer layer];
//    pulseLayer_.backgroundColor = [[UIColor redColor] CGColor];
//    pulseLayer_.bounds = CGRectMake(0., 0., 80., 80.);
//    pulseLayer_.cornerRadius = 12.;
//    pulseLayer_.position = self.view.center;
    
    [self.view.layer addSublayer:self.playerLayer];
    
    //1.判断是否支持画中画功能
    if ([AVPictureInPictureController isPictureInPictureSupported]) {
        self.pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.playerLayer];
        self.pipVC.delegate = self;
    }else{
        NSLog(@"不支持画中画");
    }
    [self.player play];
}
-(void)creatBtn{
    UIButton * switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchBtn setFrame:CGRectMake(20, 20, 50, 40)];
    [switchBtn setBackgroundColor:[UIColor whiteColor]];
    UIImage *image = [[UIImage imageNamed:@"Classcenter_draw"] imageWithTintColor:[UIColor blackColor]];
    [switchBtn setImage:image forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: switchBtn];
}
-(void)switchBtnClick:(UIButton*)sender{
    if([AVPictureInPictureController isPictureInPictureSupported]){
        //判断当前是否为画中画
        if (self.pipVC.isPictureInPictureActive) {
            //关闭画中画
            [self.pipVC stopPictureInPicture];
        } else {
            //开始画中画
            [self.pipVC startPictureInPicture];
        }
    }else{
        NSLog(@"不支持画中画");
    }
}
// 即将开启画中画
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"即将开启画中画");
}
// 已经开启画中画
- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"已经开启画中画");
}
// 开启画中画失败
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error{
    NSLog(@"开启画中画失败");
}
// 即将关闭画中画
- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"即将关闭画中画");
}
// 已经关闭画中画
- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    NSLog(@"已经关闭画中画");
}
// 关闭画中画且恢复播放界面
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    NSLog(@"关闭画中画且恢复播放界面");
}
@end
