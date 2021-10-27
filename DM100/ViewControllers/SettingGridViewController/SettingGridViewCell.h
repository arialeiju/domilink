//
//  SettingGridViewCell.h
//  DM100
//
//  Created by 马真红 on 2021/10/8.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingGridViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
-(void)setFitTitle:(NSString*)mstr;
@end

NS_ASSUME_NONNULL_END
