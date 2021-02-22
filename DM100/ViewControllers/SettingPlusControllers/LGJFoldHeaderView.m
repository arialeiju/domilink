//
//  LGJFoldHeaderView.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "LGJFoldHeaderView.h"

@implementation LGJFoldHeaderView
{
    BOOL _created;/**< 是否创建过 */
    UILabel *_titleLabel;/**< 标题 */
    UIImageView *IconView;/**< 展示图标 */
    UIImageView *_imageView;/**< 上下切换图标 */
    UIButton *_btn;/**< 收起按钮 */
    BOOL _canFold;/**< 是否可展开 */
    
}



- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title imaganame:(NSString *)imaganame type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold {
    if (!_created) {
        [self creatUI];
    }
    IconView.image=[UIImage imageNamed:imaganame];;
    _titleLabel.text = title;
    
    _section = section;
    _canFold = canFold;
    if (canFold) {
        _imageView.hidden = NO;
    } else {
        _imageView.hidden = YES;
    }
}

- (NSMutableAttributedString *)attributeStringWith:(NSString *)money {
    NSString *str = [NSString stringWithFormat:@"应收合计:%@", money];
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:money];
    [ats setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
    return ats;
}

- (void)creatUI {
    _created = YES;
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    //标题
    IconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
    IconView.image = [UIImage imageNamed:@"tminus"];
    [self.contentView addSubview:IconView];
    
    //其他内容
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(IconView.frame)+5, IconView.frame.origin.y, VIEWWIDTH-CGRectGetMaxX(IconView.frame)-5, IconView.frame.size.height)];
    _titleLabel.textColor=[UIColor colorWithHexString:@"#333333"];
    _titleLabel.font= [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:_titleLabel];
    
    //按钮图标
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0,VIEWWIDTH, 60);
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];
    
    //图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWWIDTH-40, 27, 12, 6)];
    _imageView.image = [UIImage imageNamed:@"setDown"];
    [self.contentView addSubview:_imageView];
    
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];//淡灰色
    [self.contentView addSubview:line];
}

- (void)setFold:(BOOL)fold {
    _fold = fold;
    if (fold) {
        _imageView.image = [UIImage imageNamed:@"setUp"];
    } else {
        _imageView.image = [UIImage imageNamed:@"setDown"];
    }
}

#pragma mark = 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    if (_canFold) {
        if ([self.delegate respondsToSelector:@selector(foldHeaderInSection:)]) {
            [self.delegate foldHeaderInSection:_section];
        }
    }else
    {
        if ([self.delegate respondsToSelector:@selector(foldHeaderInSection:)]) {
            [self.delegate clicktheHeaderInSection:_section];
        }
    }
}

@end
