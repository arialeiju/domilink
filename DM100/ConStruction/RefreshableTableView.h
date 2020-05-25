//
//  RefreshableTableView.h
//  头版
//
//  Created by YunInfo on 14-3-13.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

//#import "UITableView+XDDrawerTableView.h"

@interface RefreshableTableView:UITableView


@property(nonatomic,weak)MJRefreshHeaderView *  header;
@property(nonatomic,weak)MJRefreshFooterView * footer;

- (id)initWithFrame:(CGRect)frame usingHeaderView:(BOOL)header usingFooterView:(BOOL)footer;
-(void)MJreload;

@end
