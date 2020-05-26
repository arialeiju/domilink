//
//  CarListViewController.h
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDDynamicTree.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BDDynamicTreeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *carlistTableView;
@property (weak, nonatomic) IBOutlet UILabel *tvtitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgtitle;
@property (weak, nonatomic) IBOutlet UIView *viewtitle;
@property (weak, nonatomic) IBOutlet UIView *viewseach;
@property (weak, nonatomic) IBOutlet UITextField *etseach;
@property (weak, nonatomic) IBOutlet UIButton *btseach;
@property (weak, nonatomic) IBOutlet UIButton *btall;
@property (weak, nonatomic) IBOutlet UIButton *btonline;
@property (weak, nonatomic) IBOutlet UIButton *btoffline;
- (IBAction)clickbtall:(UIButton*)sender;
- (IBAction)clickbtonline:(UIButton*)sender;
- (IBAction)clickbtoffline:(UIButton*)sender;
- (IBAction)clickSearchButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *titlebutton;
- (IBAction)clickTitleButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
