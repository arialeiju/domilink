//
//  SettingGridViewCell.m
//  DM100
//
//  Created by 马真红 on 2021/10/8.
//  Copyright © 2021 aika. All rights reserved.
//

#import "SettingGridViewCell.h"

@implementation SettingGridViewCell
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self=[super initWithFrame:frame];
//    if (self) {
//        self=[[NSBundle mainBundle] loadNibNamed:@"SettingGridViewCell" owner:self options:nil].lastObject;
//        _mtitle=[[UILabel alloc]init];
//        _mtitle.frame=CGRectMake(0, self.contentView.frame.size.height-22, self.contentView.frame.size.width, 22);
//        _mtitle.textColor=[UIColor blackColor];
//        _mtitle.text=@"yes";
//        [self.contentView addSubview:_mtitle];
//
//        NSLog(@"initWithFrame x=%f y=%f with=%f",self.title.frame.origin.x,self.title.frame.origin.y,self.title.frame.size.width);
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //NSLog(@"awakeFromNib x=%f y=%f with=%f h=%f",self.title.frame.origin.x,self.title.frame.origin.y,self.title.frame.size.width,self.title.frame.size.height);
//    self.title.frame=CGRectMake(0, self.contentView.frame.size.height-22, self.contentView.frame.size.width, 22);
//    self.title.textColor=[UIColor blackColor];
//    self.title.text=@"yes";
    
    // 自动折行设置
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
    self.title.numberOfLines = 0;

}

-(void)setFitTitle:(NSString*)mstr
{
 //  CGRect mframe= self.title.frame;
    self.title.text=mstr;
    
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, mframe.size.width-2, 0)];
//    label.text=mstr;
//    label.font=self.title.font;
//    label.numberOfLines=0;
//    [label sizeToFit];
    
    
//    if([SwichLanguage userLanguageType]==1)//是英文
//    mframe.size.height=(label.frame.size.height>20)?40:20;
////    NSLog(@"label.frame.size.height=%f",label.frame.size.height);
//    [self.title setFrame:mframe];
}
@end
