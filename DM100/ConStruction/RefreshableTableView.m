//
//  RefreshableTableView.m
//  头版
//
//  Created by YunInfo on 14-3-13.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "RefreshableTableView.h"


@implementation RefreshableTableView

- (id)initWithFrame:(CGRect)frame usingHeaderView:(BOOL)header usingFooterView:(BOOL)footer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (footer) {
            MJRefreshFooterView *footer = [MJRefreshFooterView footer];
            footer.scrollView = self;
            self.footer = footer;
        }
        
        if (header) {
            MJRefreshHeaderView *header = [MJRefreshHeaderView header];
            header.scrollView = self;
            self.header = header;
        }
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)dealloc
{
    //NSAssert(self.header, @"self.headerer == nil !!!");
    if (self.footer!=NULL) {
        [self.footer free];
    }
    if (self.header!=NULL) {
        [self.header free];
    }
    
    [self.footer removeFromSuperview];
    [self.header removeFromSuperview];

}


-(void)removeFromSuperview
{
    self.footer.scrollView = nil;
    self.header.scrollView = nil;
    [super removeFromSuperview];
}
-(void)MJreload
{
    [self reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
