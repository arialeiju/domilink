//
//  ZhouQiDailgo.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZhouQiDailogDelegate <NSObject>

- (void)SureButtonAction:(NSString*_Nonnull)mcmd;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ZhouQiDailog : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelbutton;
@property (weak, nonatomic) IBOutlet UILabel *houslabel;
@property (weak, nonatomic) IBOutlet UILabel *minlabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *tiplabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic, weak) id <ZhouQiDailogDelegate> delegate ;
- (void)showInView:(UIView *)view andIMEI:(NSString*)mimti;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
