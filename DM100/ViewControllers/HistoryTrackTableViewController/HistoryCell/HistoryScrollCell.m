//
//  HistoryScrollCell.m
//  DM100
//
//  Created by 马真红 on 2021/5/26.
//  Copyright © 2021 aika. All rights reserved.
//

#import "HistoryScrollCell.h"

@implementation HistoryScrollCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createUI
{
    //CGFloat labelW = [UIScreen mainScreen].bounds.size.width / 5;
    CGFloat labelW = 80;
    
    CGFloat namewith=48;//设置ID宽度
    self.nameLabel = [UILabel new];
    self.nameLabel.frame = CGRectMake(0, 0, namewith, 44);
    self.nameLabel.text = @"";
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(namewith, 0, [UIScreen mainScreen].bounds.size.width-namewith, 44)];
    NSArray *arr = @[@"1", @"2", @"3",@"4",@"5"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel new];
        switch (idx) {
            case 0:
                label.frame = CGRectMake(labelW * idx, 0, labelW, 44);
                break;
            case 1:
                label.frame = CGRectMake(labelW * idx, 0, labelW, 44);
                break;
            case 2:
                label.frame = CGRectMake(labelW * idx, 0, labelW+70, 44);
                break;
            case 3:
                label.frame = CGRectMake(labelW * idx+70, 0, labelW, 44);
                break;
            case 4:
                label.frame = CGRectMake(labelW * idx+70, 0, labelW, 44);
                break;
            default:
                break;
        }
        //label.text = obj;
        label.tag=1000+idx;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self.rightScrollView addSubview:label];
    }];
    
    self.rightScrollView.showsVerticalScrollIndicator = NO;
    self.rightScrollView.showsHorizontalScrollIndicator = NO;
    self.rightScrollView.contentSize = CGSizeMake(labelW * arr.count+70, 0);
    self.rightScrollView.delegate = self;
    
    [self.contentView addSubview:self.rightScrollView];
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightScrollView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
}
-(void)initWithCellModel:(SS_Model *)model andArray:(NSArray *)array;
{
    self.nameLabel.text=model.title;
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self.rightScrollView viewWithTag:1000+idx];
       
        if (label.tag==1000)
        {
            label.text=model.str1;
        }
        else if (label.tag==1001)
        {
            label.text=model.str2;
        }
        else if (label.tag==1002)
        {
            label.text=model.str3;
        }
        else if (label.tag==1003)
        {
            label.text=model.str4;
        }
        else if (label.tag==1004)
        {
            label.text=model.str5;
        }
        
    }];
    
    
    
    
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
        [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
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
