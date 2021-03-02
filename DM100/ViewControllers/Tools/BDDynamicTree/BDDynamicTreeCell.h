

#import <UIKit/UIKit.h>
#import "BDDynamicTreeNode.h"
#define DepartmentCellHeight 40
typedef enum {
    CellType_Department = 1, //目录
    CellType_Employee   //雇员
}CellType;

@interface BDDynamicTreeCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *plusImageView;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

- (void)fillWithNode:(BDDynamicTreeNode*)node;

@end
