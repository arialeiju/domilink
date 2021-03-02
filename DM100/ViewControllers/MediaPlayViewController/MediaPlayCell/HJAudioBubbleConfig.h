//
//  HJAudioBubbleConfig.h
//  CarConnection
//
//  Created by 马真红 on 2018/9/3.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kHJAudioBubbleConfig [HJAudioBubbleConfig sharedAudioBubbleConfig]

@interface HJAudioBubbleConfig : NSObject
+ (instancetype)sharedAudioBubbleConfig;


/** 当前正在动画的AudioBubble */
@property (nonatomic, weak) UIImageView *animatingBubble;

/** 当前正在选中的msgId */
@property (nonatomic, copy) NSString * msgId;

#pragma mark - 页面显示控制


/**
 * 动画控制
 */
/** 声音默认图片 */
@property (nonatomic, strong) UIImage *voiceDefaultImage;

/** 声音默认图片2 */
@property (nonatomic, strong) UIImage *voiceDefaultImage2;

/** 声音图片数组 */
@property (nonatomic, strong) NSArray *voiceAnimationImages;
/** 声音动画时长 */
@property (nonatomic, assign) CGFloat duration;
/**
 * 音频播放
 */
//@property (nonatomic, strong)NSString *currentPlayMusic;//记录当前播放的歌曲url
- (void)playerWithURL:(NSString *)usrString andTopUrl:(NSString*)topurl;//播放歌曲，上一曲  下一曲
- (void)myPlay;//播放
- (void)myPause;//暂停
-(BOOL)isPlayIng;
@end
