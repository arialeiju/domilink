//
//  DSViewCell.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/24.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DSCellH 30
NS_ASSUME_NONNULL_BEGIN
@protocol DSViewCellItemDelegate <NSObject>

- (void)DoSelectTime:(NSInteger)SectionItem;
- (void)DoMinusAction:(NSInteger)SectionItem;
@end
@interface DSViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UIButton *lastbutton;
@property(nonatomic, weak) id<DSViewCellItemDelegate> delegate;/**< 代理 */
- (IBAction)clicklastbutton:(id)sender;
@end

NS_ASSUME_NONNULL_END
