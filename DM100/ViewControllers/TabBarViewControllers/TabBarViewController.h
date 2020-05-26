//
//  TabBarViewController.h
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TabBarFooterView;

@interface TabBarViewController : UITabBarController<UITabBarDelegate>
@property (nonatomic, strong) TabBarFooterView *tabBarFooterView;
-(void)setSelectedIndex:(NSUInteger)selectedIndex;
@end

NS_ASSUME_NONNULL_END
