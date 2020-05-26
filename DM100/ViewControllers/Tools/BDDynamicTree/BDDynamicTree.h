

#import <UIKit/UIKit.h>

@class BDDynamicTree;
@class BDDynamicTreeNode;

@protocol BDDynamicTreeDelegate <NSObject>
@optional
- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node;
@end

@interface BDDynamicTree : UIView
@property (nonatomic,assign) id <BDDynamicTreeDelegate>delegate;

/*!
 *@method initWithFrame:nodes:
 *@abstract 初始化
 *@param frame  坐标大小
 *@param nodes  `BDDynamicTreeNode`数组
 *@return 当前对象
 */
- (id)initWithFrame:(CGRect)frame nodes:(NSArray *)nodes;

-(void)reloadTheUserListTableView:(NSArray*)nodes;
-(void)settableViewFrame:(CGRect)frame;

-(void)setTheFirstSelectItem;
@end
