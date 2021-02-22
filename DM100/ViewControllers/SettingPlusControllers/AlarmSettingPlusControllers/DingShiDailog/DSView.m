//
//  DSView.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/24.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "DSView.h"
@implementation DSView

-(instancetype)initWithFrame: (CGRect)frame
{
 if (self = [super initWithFrame: frame]) {
     UIButton *button = [UIButton new];
     [button setBackgroundImage:[UIImage imageNamed:@"setmius"] forState:UIControlStateNormal];
     [self addSubview: button]; // 将button加到view中，并不设置尺寸
     self.lastbutton = button; //将self.button指向这个button保证在layoutSubviews中可以访问
         
     UILabel *label = [UILabel new];
     label.textColor=[UIColor blackColor];
     label.font=[UIFont systemFontOfSize:15.0f];
     label.text=@"时间:";
     [self addSubview:label];
     self.titlelabel=label;
     
     UILabel *mconlabel = [UILabel new];
     mconlabel.textColor=[UIColor blackColor];
     //mconlabel.layer.borderColor = [[UIColor colorWithHexString:@"#F9F9F9"] CGColor];
     mconlabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
     mconlabel.layer.borderWidth = 1.0f;//设置边框粗细
     mconlabel.text=@"00:00";
     mconlabel.textAlignment=NSTextAlignmentCenter;
     mconlabel.font=[UIFont systemFontOfSize:15.0f];
     [self addSubview:mconlabel];
     self.contentlabel=mconlabel;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews]; // 注意，一定不要忘记调用父类的layoutSubviews方法！

    // self.button.frame = ... // 设置button的frame
    CGFloat mainH=self.bounds.size.height;
    CGFloat mainW=self.bounds.size.width;
    CGFloat contW=60;//时间选择器的大小
    self.contentlabel.frame =CGRectMake(mainW/2-contW/2, 1, contW, mainH-2);
    
    self.titlelabel.frame =CGRectMake(0, 1, self.contentlabel.frame.origin.x, mainH-2);
    
    CGFloat buttonsize=self.contentlabel.frame.size.height-4;
    self.lastbutton.frame= CGRectMake(CGRectGetMaxX(self.contentlabel.frame)+10, mainH/2-buttonsize/2, buttonsize,buttonsize);
}
@end
