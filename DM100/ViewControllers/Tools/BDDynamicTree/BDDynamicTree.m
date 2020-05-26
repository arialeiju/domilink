

#import "BDDynamicTree.h"
#import "BDDynamicTreeNode.h"
#import "BDDynamicTreeCell.h"
@interface BDDynamicTree () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //NSMutableArray *_dataSource;
    NSMutableArray *_nodesArray;
    InAppSetting *myDelegate;
}
@end

@implementation BDDynamicTree

- (id)initWithFrame:(CGRect)frame nodes:(NSArray *)nodes
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //myDelegate=[[UIApplication sharedApplication]delegate];
        myDelegate=self.inAppSetting;
        
       // _dataSource = [[NSMutableArray alloc] init];
        _nodesArray = [[NSMutableArray alloc] init];
        
        if (nodes && nodes.count) {
            [_nodesArray addObjectsFromArray:nodes];
            
            //添加根节点
            if (myDelegate._dataSource==nil) {
                myDelegate._dataSource= [NSMutableArray array];
                [myDelegate._dataSource addObject:[self rootNode]];
            }
            
        }
        
        //tableview
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView setTableFooterView:[UIView new]];
        [self addSubview:_tableView];
        
        //设置初始被选中的位置
//        if (myDelegate.indexPath!=nil) {
//            
//            //[_tableView scrollToRowAtIndexPath:myDelegate.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//            
//            [_tableView selectRowAtIndexPath:myDelegate.indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//        }
    }
    return self;
}

-(void)setTheFirstSelectItem
{
    //设置初始被选中的位置
    if (myDelegate.indexPath!=nil) {
        
        //[_tableView scrollToRowAtIndexPath:myDelegate.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [_tableView selectRowAtIndexPath:myDelegate.indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)reloadTheUserListTableView:(NSArray*)nodes
{
    [_tableView reloadData];
}

-(void)settableViewFrame:(CGRect)frame
{
    [_tableView setFrame:frame];
}
#pragma mark - private methods

- (BDDynamicTreeNode *)rootNode
{
    for (BDDynamicTreeNode *node in _nodesArray) {
        if ([node isRoot]) {
            return node;
        }
    }
    return nil;
}

//添加子节点
- (void)addSubNodesByFatherNode:(BDDynamicTreeNode *)fatherNode atIndex:(NSInteger )index
{
    if (fatherNode)
    {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *cellIndexPaths = [NSMutableArray array];
        
        NSUInteger count = index;
        for(BDDynamicTreeNode *node in _nodesArray) {
            if ([node.fatherNodeId isEqualToString:fatherNode.nodeId]) {
                node.originX = fatherNode.originX + 15/*space*/;
                [array addObject:node];
                [cellIndexPaths addObject:[NSIndexPath indexPathForRow:count++ inSection:0]];
            }
        }
        
        if (array.count) {
            fatherNode.isOpen = YES;
            fatherNode.subNodes = array;
            
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index,[array count])];
            [myDelegate._dataSource insertObjects:array atIndexes:indexes];
            [_tableView insertRowsAtIndexPaths:cellIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [_tableView reloadData];
        }
    }
}

//根据节点减去子节点
- (void)minusNodesByNode:(BDDynamicTreeNode *)node
{
    if (node) {
        
        NSMutableArray *nodes = [NSMutableArray arrayWithArray:myDelegate._dataSource];
        for (BDDynamicTreeNode *nd in nodes) {
            if ([nd.fatherNodeId isEqualToString:node.nodeId]) {
                [myDelegate._dataSource removeObject:nd];
                [self minusNodesByNode:nd];
            }
        }
        
        node.isOpen = NO;
        [_tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myDelegate._dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DepartmentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BDDynamicTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* topObjects = [[NSBundle mainBundle] loadNibNamed:@"BDDynamicTreeCell" owner:self options:nil];
        cell = [topObjects objectAtIndex:0];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor =[UIColor colorWithHexString:@"#00B7EE"];
        bgColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgColorView;
    }
    
//    if (myDelegate.indexPath!=nil&&myDelegate.indexPath.row==indexPath.row&&indexPath.section==myDelegate.indexPath.section)
//    {
//        NSLog(@"相同刷新高亮");
//        cell.selected=YES;
//    }
    [cell fillWithNode:myDelegate._dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDDynamicTreeNode *node = myDelegate._dataSource[indexPath.row];
    
    Boolean callMainView=true;//判断是否需要刷新用户拥有车辆信息
    
    if (node.isDepartment) {
        if (node.isOpen) {
            //减
            [self minusNodesByNode:node];
            
           // node.isOpen = NO;
           // [.dict replaceObjectAtIndex:indexPath.row withObject:node];
        }
        else{
            //加一个
            NSUInteger index=indexPath.row+1;
            
            [self addSubNodesByFatherNode:node atIndex:index];
            callMainView=false;
           // node.isOpen = YES;
           // [myDelegate.dict replaceObjectAtIndex:indexPath.row withObject:node];
        }
    }
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if (callMainView) {
        //callback
        myDelegate.indexPath=indexPath;
        myDelegate.curloginNo=node.loginNo;
        myDelegate.curuserId=node.nodeId;
        myDelegate.curusername=node.name;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicTree:didSelectedRowWithNode:)]) {
            [self.delegate dynamicTree:self didSelectedRowWithNode:node];
        }
    }
}

@end
