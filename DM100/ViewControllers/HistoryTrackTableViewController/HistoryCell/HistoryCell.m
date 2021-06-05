//
//  HistoryCell.m
//  CarConnection
//
//  Created by 马真红 on 2019/5/13.
//  Copyright © 2019 gemo. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    CGSize msize=self.scrollView.contentSize;
    NSLog(@"h=%f  w=%f",msize.height,msize.width);
    self.scrollView.contentSize=CGSizeMake(520, 0);
    self.scrollView.alwaysBounceVertical=NO;
    self.scrollView.delegate=self;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.scrollView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_isNotification)
    {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification)
    {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self)
    {
        _isNotification = YES;
        [_scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }
    else
    {
        _isNotification = NO;
    }
    obj = nil;
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    __weak typeof (self) weakSelf = self;
    if (self.tapCellClick) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf];
        weakSelf.tapCellClick(indexPath);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

    
@end
