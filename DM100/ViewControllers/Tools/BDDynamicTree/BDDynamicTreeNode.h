#import <Foundation/Foundation.h>

@interface BDDynamicTreeNode : NSObject

@property (nonatomic, assign) CGFloat       originX;            //坐标x
@property (nonatomic, strong) NSString      *name;              //名称
@property (nonatomic, strong) NSString      *loginNo;           //节点详细,登录名
@property (nonatomic, strong) NSArray       *subNodes;          //子节点
@property (nonatomic, strong) NSString      *fatherNodeId;      //父节点的id
@property (nonatomic, strong) NSString      *nodeId;            //当前节点id
@property (nonatomic, assign) BOOL          isDepartment;       //是否是部门
@property (nonatomic, assign) BOOL          isOpen;             //是否展开的
@property (nonatomic, assign) BOOL          isLast;             //是否子部门最后一个

//检查是否根节点
- (BOOL)isRoot;

@end
