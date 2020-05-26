//
//  SelectionComboBox.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/6/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "SelectionComboBox.h"
#import "SelectionComboBoxCell.h"

@interface SelectionComboBox ()<SelectionComboBoxCellDelegate>
{
    NSMutableArray * _dataArray;
    NSMutableArray * _cellArray;
}
@end

@implementation SelectionComboBox

- (id)initWithFrame:(CGRect)frame
    withStringArray:(NSArray *)selections;
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SelectionComboBox" owner:self
                                        options:nil] firstObject];
    if (self)
    {
        _dataArray = [selections mutableCopy];
        _cellArray = [NSMutableArray array];
        self.frame = frame;
        [self loadSelections];
    }
    return self;
}

- (void)loadSelections
{
    if (_cellArray.count != 0)
    {
        for (SelectionComboBoxCell *oldCell in _cellArray)
        {
            [oldCell removeFromSuperview];
        }
        [_cellArray removeAllObjects];
    }
    
    CGRect cellFrame = CGRectMake(0, 0,
                                  CGRectGetWidth(self.frame),
                                  SelectionComboBoxCellHeight);
    int index = 0;
    for (NSString *string in _dataArray)
    {
        SelectionComboBoxCell *cell = [[SelectionComboBoxCell alloc] initWithFrame:cellFrame
                                                                        withString:string];
        cell.delegate = self;
        cell.tag = index++;
        [self addSubview:cell];
        [_cellArray addObject:cell];
        
        cellFrame.origin.y += SelectionComboBoxCellHeight;
    }

    CGRect newFrame = self.frame;
    newFrame.size.height = cellFrame.origin.y;
    self.frame = newFrame;
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

#pragma mark - SelectionComboBoxCellDelegate
- (void)selectionComboBoxCellCloseButtonDidPush:(SelectionComboBoxCell *)cell
{
    [_dataArray removeObjectAtIndex:cell.tag];
    [self loadSelections];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectionCombox:didDeleteRow:)])
    {
        [_delegate selectionCombox:self didDeleteRow:_dataArray];
    }
}

- (void)selectionComboBoxCellDidSelected:(SelectionComboBoxCell *)cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectionCombox:didSelectedAt:)])
    {
        [_delegate selectionCombox:self didSelectedAt:cell.tag];
    }
}

@end
