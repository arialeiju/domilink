//
//  ItemViewController.h
//  BLETestApp
//
//  Created by 马真红 on 2020/4/26.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mapbutton;
- (IBAction)clickmapbutton:(id)sender;

@end

NS_ASSUME_NONNULL_END
