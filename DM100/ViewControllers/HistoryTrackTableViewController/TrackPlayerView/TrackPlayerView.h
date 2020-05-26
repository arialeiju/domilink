//
//  TrackPlayerView.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/16.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrackPlayerViewDelegate <NSObject>

@optional
- (void)playPauseButtonDidPush:(UIButton *)sender;
- (void)speedButtonDidPush:(UIButton *)sender;
- (void)timeRangeButton:(UIButton *)sender;

@required
- (void)sliderValueDidChangeToStep:(NSInteger)step
                      withDuration:(CGFloat)duration;
- (void)timeRangeDidSelectedWithStartTime:(NSString *)startTime
                              withEndTime:(NSString *)endTime
                                    withSpe:(NSString *)spe;
-(void)ThejizhangStatusChange:(BOOL)theStatus;
@end

@interface TrackPlayerView : UIView

@property (weak, nonatomic) id<TrackPlayerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISlider *sliderBar;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *speedButton;
@property (weak, nonatomic) IBOutlet UIButton *timeRangeButton;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *imeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

- (void)setTotalSteps:(NSInteger)steps;
@property (weak, nonatomic) IBOutlet UILabel *showJZstatusView;
-(void)stopshowing;
@end
