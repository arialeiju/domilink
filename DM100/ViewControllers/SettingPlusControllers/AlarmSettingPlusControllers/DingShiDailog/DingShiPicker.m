//
//  DingShiPicker.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/26.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "DingShiPicker.h"
@interface DingShiPicker () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *hourArray;
    NSInteger currentHour;
    NSString *restr;
    UIPickerView *mpickerView;
    NSString *selectedHour;
    NSString *_mday;
}

@property (nonatomic, assign) NSString *startTime;
@property (nonatomic, assign) NSInteger period;

@end

@implementation DingShiPicker

/**
 初始化方法
 
 @param startHour 其实时间点 时
 @param endHour 结束时间点 时
 @param period 间隔多少分中
 @param block 返回选中的时间
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour response:(void (^)(NSString *))block{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    _startTime = startHour;
    
    [self initDataSource];
    [self initAppreaence];
    
    if (block) {
        backBlock = block;
    }
    return self;
}

#pragma mark - initDataSource
- (void)initDataSource {
    
    [self configHourArray];
    
    selectedHour = hourArray[0];
    _mday=[SwichLanguage getString:@"day"];
    
//    [self.sendbutton setTitle:[SwichLanguage getString:@"send"] forState:UIControlStateNormal];
//    [self.cancelbutton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
}

- (void)configHourArray {//配置小时数据源数组
    //初始化小时数据源数组
    hourArray = [[NSMutableArray alloc]init];
    
    for(int i=1;i<31;i++)
    {
        [hourArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}


#pragma mark - initAppreaence
- (void)initAppreaence {

    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    [self addSubview:contentView];
    //设置背景颜色为黑色，并有0.4的透明度
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
        [button setTitle:i == 0 ? [SwichLanguage getString:@"cancel"] : [SwichLanguage getString:@"sure"] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    mpickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    mpickerView.delegate = self;
    mpickerView.dataSource = self;
    mpickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    
    //设置pickerView默认第一行 这里也可默认选中其他行 修改selectRow即可
    
    if([hourArray indexOfObject:_startTime] != NSNotFound) {
        NSInteger inde =[hourArray indexOfObject:_startTime] ;
        [mpickerView selectRow:inde inComponent:0 animated:NO];
        selectedHour=_startTime;
    }else
    {
        [mpickerView selectRow:0 inComponent:0 animated:YES];
    }
    
    [contentView addSubview:mpickerView];
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        
        restr = [NSString stringWithFormat:@"%@",selectedHour];
    
        backBlock(restr);
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}

#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        return hourArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return [NSString stringWithFormat:@"%@%@",hourArray[row],_mday];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        selectedHour = hourArray[row];
}
@end
