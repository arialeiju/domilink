//
//  HJAudioBubbleConfig.m
//  CarConnection
//
//  Created by 马真红 on 2018/9/3.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import "HJAudioBubbleConfig.h"
#import "HJBlockOperation.h"
#import "VoiceConverter.h"
//#define URLTOP @"http://47.106.108.159:8088/upload/audios/"//连接头

@interface HJAudioBubbleConfig()<AVAudioPlayerDelegate>
{
    MBProgressHUD * _HUD;
    BOOL isplaying;
}

@property (nonatomic, strong)AVAudioPlayer* player;
@end

@implementation HJAudioBubbleConfig
#pragma mark - 单例内容
static  HJAudioBubbleConfig * shareSingleton;

+ (instancetype)sharedAudioBubbleConfig{
    static  dispatch_once_t  onceToken;
    dispatch_once (&onceToken, ^ {
        shareSingleton  =  [[super allocWithZone:NULL] init] ;
        [shareSingleton buildDefaultDatas];
    } );
    return shareSingleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedAudioBubbleConfig] ;
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [self sharedAudioBubbleConfig];
}

#pragma mark - 业务内容
- (void)buildDefaultDatas{
    isplaying=false;
    //设置播放动画图片
    self.duration = 0.5f;
    
    self.voiceDefaultImage = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    
    self.voiceDefaultImage2=[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"];
    
    self.voiceAnimationImages = @[
                                  [UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],
                                  [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],
                                  [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"]];
    
    
}


//切换歌曲或者为播放器加载资源的方法
- (void)playerWithURL:(NSString *)usrString andTopUrl:(NSString*)topurl{
    NSString* theBool=[self isFileExist:[self nameAmrToWav:usrString]];
    if (![theBool isEqualToString:@""]) {
        //已经存在，直接播放
        NSData* convertData = [NSData dataWithContentsOfFile:theBool];
        //初始化播放器，播放converData
        [self startToVoice:convertData];
    }else
    {//开始下载数据

        [self loadAmrData:usrString andTopUrl:(NSString*)topurl];
    }
}




//播放
- (void)myPlay{
    
    [self.player play];
    isplaying=true;
}

//暂停
- (void)myPause{
    
    [self.player pause];
    isplaying=false;
}

//下载延时网络数据
-(void)loadAmrData:(NSString*)userUrl andTopUrl:(NSString*)topurl
{
    
    //创建url字符串
    NSString* theurl=[NSString stringWithFormat:@"%@%@",topurl,userUrl];
    //theurl=@"http://test.basegps.com/cctv.mp3";
    NSLog(@"playerWithURL=%@",theurl);
    
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    NSMutableArray *operaArray = [NSMutableArray array];
    for (int index = 0; index < 1; index ++) {
        
        HJBlockOperation *blo = [[HJBlockOperation alloc] init];
        
        [blo continueWithBlock:^(HJBlockOperation *con) {
            
            NSLog(@"第%d条任务开始",index + 1);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSLog(@"第%d条任务结束",index + 1);
                
                //等任务结束后调用这句代码，就标明此操作已结束
                blo.hjFinished = YES;
            });
            
        }];
        
        [operaArray addObject:blo];
    }
    
    
    HJBlockOperation *operation = [[HJBlockOperation alloc] init];
    
    [operation continueWithBlock:^(HJBlockOperation *con) {
        
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:theurl]];
        NSLog(@"开始下载");
        if (data) {
            operation.hjFinished = YES;
            
            NSLog(@"下载完了");
            dispatch_async(dispatch_get_main_queue(), ^{
                [_HUD hide:YES];
                 NSLog(@"准备播放");

                //把data写入文件中，取名AudioTempFile
                [data writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:userUrl] atomically:YES];
                
                if ([userUrl containsString:@".mp3"]) {
                    NSLog(@"mp3处理");
                    [self startToVoice:data];
                }else
                {
                    //转换名字
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString *path = [paths objectAtIndex:0];
                    NSString *newurl = [path stringByAppendingPathComponent:[self nameAmrToWav:userUrl]];
                    
                    //将数据amr格式的Data转成wav
                    [VoiceConverter ConvertAmrToWav:[NSTemporaryDirectory() stringByAppendingPathComponent:userUrl] wavSavePath:newurl];
                    //读取新的wav格式音频文件
                    NSData* convertData = [NSData dataWithContentsOfFile:newurl];
                    //初始化播放器，播放converData
                    [self startToVoice:convertData];
                }
                
            });
        }
    }];
    [operaArray addObject:operation];
    
    [queue addOperations:operaArray waitUntilFinished:NO];
    
}

//播放音频
-(void)startToVoice:(NSData*)data
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    self.player = [[AVAudioPlayer alloc] initWithData:data error:NULL];
    self.player.delegate=self;
    [self.player prepareToPlay];
    [self.player play];
    isplaying=true;
}

//判断文件是否已经在沙盒中已经存在？
-(NSString*) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    //NSLog(@"fileManager=%@",filePath);
    if (result) {
        return filePath;
    }else
    {
        return @"";
    }
}

//amr转wav名字
-(NSString*)nameAmrToWav:(NSString*)thename
{
    NSString *d5 = [thename stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
    //NSLog(@"old=%@||new=%@",thename,d5);
    return d5;
}

#pragma mark - AVAudioPlayerDelegate

// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    // 音频播放完成时，调用该方法。
    // 参数flag：如果音频播放无法解码时，该参数为NO。
    //当音频被终端时，该方法不被调用。而会调用audioPlayerBeginInterruption方法
    // 和audioPlayerEndInterruption方法
    
     //NSLog(@"播放完成！");
    self.animatingBubble.image=self.voiceDefaultImage;
    isplaying=false;
}

// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"解码错误！");
    isplaying=false;
}

// 当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    // 当音频播放过程中被中断时，执行该方法。比如：播放音频时，电话来了！
    // 这时候，音频播放将会被暂停。
    self.animatingBubble.image=self.voiceDefaultImage;
    isplaying=false;
}

-(BOOL)isPlayIng
{
    return isplaying;
}
@end
