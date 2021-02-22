//
//  DSViewCell.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/24.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "DSViewCell.h"

@implementation DSViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentlabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.contentlabel.layer.borderWidth = 1.0f;//设置边框粗细
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self.contentView addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clicklastbutton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DoMinusAction:)]) {
        [self.delegate DoMinusAction:self.tag];
    }
}

-(void)event:(UITapGestureRecognizer *)gesture
 {
    //处理事件
     if ([self.delegate respondsToSelector:@selector(DoSelectTime:)]) {
         [self.delegate DoSelectTime:self.tag];
     }
 }
@end
