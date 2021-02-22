//
//  AKRadioPopView.h
//  单选弹出框
//
//  Created by 马真红 on 2020/10/24.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AKRadioPopViewDelegate <NSObject>

- (void)getTheButtonTitleWithIndexPath:(int)indexPath;

@end
NS_ASSUME_NONNULL_BEGIN

@interface AKRadioPopView : UIView
/**
 *  内容视图
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  按钮高度
 */
@property (nonatomic, assign) CGFloat buttonH;
/**
 *  按钮的垂直方向的间隙
 */
@property (nonatomic, assign) CGFloat buttonMargin;
/**
 *  内容视图的位移
 */
@property (nonatomic, assign) CGFloat contentShift;
/**
 *  动画持续时间
 */
@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, weak) id <AKRadioPopViewDelegate> QCPopViewDelegate ;

/**
 *  展示popView
 *
 *  @param array button的title数组
 */
- (void)showThePopViewWithArray:(NSMutableArray *)array AndTitle:(NSString*)mtitle;

//写一个展示view的操作




/**
 *  移除popView
 */
- (void)dismissThePopView;@end

// 自适配单选弹出框 使用demo：
//设置定位类型单选项目
//_titleArray= [[NSMutableArray alloc] initWithObjects: @"item1",@"item2",@"item3",nil];
//打开设置定位类型弹出框
//- (void)showLoctionTypeSettingDailog{
//    //初始化
//    _mAKRadioPopView = [[AKRadioPopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
//    //遵守协议
//    _mAKRadioPopView.QCPopViewDelegate = self;
//    //传递数据
//    [_mAKRadioPopView showThePopViewWithArray:self.titleArray AndTitle:@"设置定位类型"];
//}
//#pragma mark - QCPopViewDelegate
//-(void)getTheButtonTitleWithIndexPath:(int)indexPath{
//
//
//    NSString *buttonStr = self.titleArray[indexPath];
//    NSLog(@"buttonStr=%@",buttonStr);
//}
NS_ASSUME_NONNULL_END
