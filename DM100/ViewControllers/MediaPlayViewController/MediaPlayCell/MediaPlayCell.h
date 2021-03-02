//
//  MediaPlayCell.h
//  CarConnection
//
//  Created by 马真红 on 2018/9/3.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJAudioBubbleConfig.h"
typedef void(^CellBubbleLongPressCallBack)();


@interface MediaPlayCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIconV;
/** HJAudioBubbleConfig */
@property (nonatomic, strong) HJAudioBubbleConfig *bubbleConfig;
@property (weak, nonatomic) IBOutlet UIView *voicebackgroud;
@property (weak, nonatomic) IBOutlet UILabel *voicelenthlabel;
/** 长按回调 */
@property (nonatomic, copy)CellBubbleLongPressCallBack longPressCallBack;
@property (weak, nonatomic) IBOutlet UILabel *loctionlabel;

/** 链接名称 */
@property (nonatomic, copy) NSString * urlname;

@property (nonatomic, copy) NSString * msgId;
@end
