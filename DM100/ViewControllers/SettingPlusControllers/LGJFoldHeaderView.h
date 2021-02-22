//
//  LGJFoldHeaderView.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HerderStyle) {
    HerderStyleNone,
    HerderStyleTotal
};
@protocol FoldSectionHeaderViewDelegate <NSObject>

- (void)foldHeaderInSection:(NSInteger)SectionHeader;
- (void)clicktheHeaderInSection:(NSInteger)SectionHeader;
@end
@interface LGJFoldHeaderView : UITableViewHeaderFooterView
@property(nonatomic, assign) BOOL fold;/**< 是否折叠 */
@property(nonatomic, assign) NSInteger section;/**< 选中的section */
@property(nonatomic, weak) id<FoldSectionHeaderViewDelegate> delegate;/**< 代理 */


- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title imaganame:(NSString *)imganame type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold;@end

NS_ASSUME_NONNULL_END
