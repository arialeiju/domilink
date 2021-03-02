//
//  MediaPlayCell.m
//  CarConnection
//
//  Created by 马真红 on 2018/9/3.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import "MediaPlayCell.h"

@implementation MediaPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.baseview.layer.borderWidth = 1;
    self.baseview.layer.borderColor = [[UIColor grayColor] CGColor];//设置列表边框
    
    self.baseview.layer.masksToBounds = YES;
    self.baseview.layer.cornerRadius = 5;
    
    self.bubbleConfig = kHJAudioBubbleConfig;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioBubbleClicked:)];
    [self.voicebackgroud addGestureRecognizer:tap];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(audioBubbleLongPress:)];
    [self addGestureRecognizer:longPress];
    
    [self refreshUI];
    
    [self.loctionlabel setText:[SwichLanguage getString:@"locationdetails"]];
}
- (void)audioBubbleLongPress:(UILongPressGestureRecognizer *)longPress{
    
    //NSLog(@"测试2 msgId=%@",self.msgId);
    if (longPress.state == UIGestureRecognizerStateEnded) {
            [self stopAnimating];
        //删除消息
        if (self.longPressCallBack) {
            self.longPressCallBack();
        }
    }
}

#pragma mark - Public Method
//开始动画
- (void)startAnimating;{
    NSLog(@"startAnimating=%@",self.urlname);
    if (self.bubbleConfig.animatingBubble) {
        self.bubbleConfig.animatingBubble.image=self.bubbleConfig.voiceDefaultImage;
        self.bubbleConfig.animatingBubble = nil;
        self.bubbleConfig.msgId=nil;
    }
    self.playIconV.image=self.bubbleConfig.voiceDefaultImage2;
    self.bubbleConfig.msgId=self.msgId;
    
    
    NSArray *marray=[self.urlname componentsSeparatedByString:@"/"];
    NSString* murlname=[marray lastObject];
    NSString* mtopurl=[self.urlname substringToIndex:(self.urlname.length-murlname.length)];
    NSLog(@"murlname=%@",murlname);
    NSLog(@"mtopurl=%@",mtopurl);
    [self.bubbleConfig playerWithURL:murlname andTopUrl:mtopurl];
    self.bubbleConfig.animatingBubble = self.playIconV;
}
//结束动画
- (void)stopAnimating;{
    NSLog(@"stopAnimating=%@",self.urlname);
    self.playIconV.image=self.bubbleConfig.voiceDefaultImage;
    self.bubbleConfig.msgId=nil;
    [self.bubbleConfig myPause];
}

#pragma mark - Event response
- (void)audioBubbleClicked:(UITapGestureRecognizer *)tap{
    
    if (self.playIconV.isAnimating) {
        [self stopAnimating];
    }else{
        [self startAnimating];
    }
//    if (self.bubbleClickBlock) {
//        self.bubbleClickBlock(self.playIconV.isAnimating);
//    }
}

- (void)refreshUI{
    
    //设置播放动画图片
    _playIconV.image = self.bubbleConfig.voiceDefaultImage;
    _playIconV.animationDuration = self.bubbleConfig.duration;
    _playIconV.animationImages = self.bubbleConfig.voiceAnimationImages;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
