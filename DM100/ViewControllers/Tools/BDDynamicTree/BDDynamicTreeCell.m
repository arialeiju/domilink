

#import "BDDynamicTreeCell.h"
@interface BDDynamicTreeCell ()
@end

@implementation BDDynamicTreeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.avatarImageView.layer.cornerRadius = 5.f;
//    self.avatarImageView.layer.masksToBounds = YES;
}


- (void)fillWithNode:(BDDynamicTreeNode*)node
{
    if (node) {
        NSInteger cellType = node.isDepartment;
        
        [self setCellStypeWithType:cellType originX:node.originX];
        
        if (cellType == CellType_Department) {
            if ([node isRoot]) {
                self.labelTitle.text = [NSString stringWithFormat:@"%@",node.name];
            }else{
                self.labelTitle.text = [NSString stringWithFormat:@"%@(%lu)",node.name,(unsigned long)node.subNodes.count];
            }
            
            if (node.isOpen) {
                self.plusImageView.image = [UIImage imageNamed:@"tminus"];
            }else
            {
                self.plusImageView.image = [UIImage imageNamed:@"tplus"];
            }
        }
        else{
            
            self.labelTitle.text = [NSString stringWithFormat:@"%@",node.name];
            if (node.isLast) {
                self.plusImageView.image = [UIImage imageNamed:@"tend"];
            }else
            {
                self.plusImageView.image = [UIImage imageNamed:@"tmiddle"];
            }
        }
    }
}

- (void)setCellStypeWithType:(NSInteger)type originX:(CGFloat)x
{
    if (type == CellType_Department) {
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width, DepartmentCellHeight);
        
        //self.avatarImageView.hidden = YES;
        
        //设置 + 号的位置
        self.plusImageView.frame = CGRectMake(x, self.plusImageView.frame.origin.y,
                                              self.plusImageView.frame.size.width,
                                              self.plusImageView.frame.size.height);
        
        //设置 + 号的位置
        self.userImageView.frame = CGRectMake(CGRectGetMaxX(self.plusImageView.frame)+10, self.userImageView.frame.origin.y,
                                              self.userImageView.frame.size.width,
                                              self.userImageView.frame.size.height);
        
        //设置 label的位置
        self.labelTitle.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 5/*space*/, 0,
                                           self.contentView.frame.size.width - CGRectGetMaxX(self.userImageView.frame) - 5 - 5/*space*/,
                                           self.contentView.frame.size.height);
        
        self.userImageView.image = [UIImage imageNamed:@"tuser-group"];
        
    }
    else{
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width, DepartmentCellHeight);
        
        //self.avatarImageView.hidden = YES;
        
        //设置 + 号的位置
       self.plusImageView.frame = CGRectMake(x, self.plusImageView.frame.origin.y,
                                              self.plusImageView.frame.size.width,
                                              self.plusImageView.frame.size.height);
       // self.plusImageView.hidden=YES;
        //设置 label的位置
//        self.labelTitle.frame = CGRectMake(self.plusImageView.frame.origin.x+self.plusImageView.frame.size.width + 5/*space*/, 0,
//                                           self.contentView.frame.size.width - self.plusImageView.frame.origin.x - self.plusImageView.frame.size.width - 5 - 5/*space*/,
//                                           self.contentView.frame.size.height);
        //设置 + 号的位置
        self.userImageView.frame = CGRectMake(CGRectGetMaxX(self.plusImageView.frame)+10, self.userImageView.frame.origin.y,
                                              self.userImageView.frame.size.width,
                                              self.userImageView.frame.size.height);
        
        //设置 label的位置
        self.labelTitle.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + 5/*space*/, 0,
                                           self.contentView.frame.size.width - CGRectGetMaxX(self.userImageView.frame) - 5 - 5/*space*/,
                                           self.contentView.frame.size.height);
        
        self.userImageView.image = [UIImage imageNamed:@"tuser-single"];
    }
}

@end
