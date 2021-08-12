//
//  DingShiDailog.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DingShiDailogDelegate <NSObject>

- (void)SureButtonDingShiAction:(NSString*_Nonnull)mcmd;

@end
NS_ASSUME_NONNULL_BEGIN
@interface DingShiDailog : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelbutton;
@property (weak, nonatomic) IBOutlet UIView *buttomview;
@property (weak, nonatomic) IBOutlet UILabel *tiplabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) id <DingShiDailogDelegate> delegate ;
- (void)showInView:(UIView *)view andIMEI:(NSString*)mimti andShowType:(int)mtype;
-(void)hide;
- (IBAction)DoNewAddAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
