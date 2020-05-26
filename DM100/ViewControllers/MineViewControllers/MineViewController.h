//
//  MineViewController.h
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mineFunctionTableView;

@end

NS_ASSUME_NONNULL_END
