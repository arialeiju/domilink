

#import "BDDynamicTreeNode.h"

@implementation BDDynamicTreeNode

- (BOOL)isRoot
{
    return self.fatherNodeId == nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@",self.name];
}

@end