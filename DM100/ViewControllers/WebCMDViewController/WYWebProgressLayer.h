//
//  WebviewProgressLine.h
//  CarConnection
//
//  Created by 马真红 on 17/11/21.
//  Copyright © 2017年 gemo. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface WYWebProgressLayer : CAShapeLayer
+ (instancetype)layerWithFrame:(CGRect)frame;
- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end