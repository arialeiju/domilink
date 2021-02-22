//
//  AKRadioPopView.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/24.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "AKRadioPopView.h"
#define LineColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]


@interface AKRadioPopView()
{
    NSMutableArray *imagearray;
    int selecitem;
}
@property (nonatomic, strong) UIButton *cancelbutton;
@property (nonatomic, strong) UIButton *sendbutton;
@property (nonatomic, strong) UIView *bgView;
@end
@implementation AKRadioPopView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        //初始化各种起始属性
        [self initAttribute];
        selecitem=0;
    }
    return self;
}




/**
 *  初始化起始属性
 */

- (void)initAttribute{
    
    self.buttonH = VIEWHEIGHT * (40.0/736.0)+1;
    self.buttonMargin = 10;
    self.contentShift = VIEWHEIGHT * (250.0/736.0);
    self.animationTime = 0.8;
    self.backgroundColor = [UIColor colorWithWhite:0.614 alpha:0.700];
    
    [self initSubViews];
}


/**
 *  初始化子控件
 */
- (void)initSubViews{
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.frame = CGRectMake(20, 150, VIEWWIDTH-40, self.contentShift);
    [self addSubview:self.contentView];
    
}
/**
 *  展示pop视图
 *
 *  @param array 需要显示button的title数组
 */
- (void)showThePopViewWithArray:(NSMutableArray *)array AndTitle:(NSString*)mtitle{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    [window addSubview:self];
    
    //初始化动态配置UI界面
    CGFloat mY=10;//标旗位置
    CGFloat mW=self.contentView.frame.size.width;
    
    //配置标题
    UILabel * titlelabel= [[UILabel alloc]initWithFrame:CGRectMake(0, mY, mW, 30)];
    titlelabel.font = [UIFont systemFontOfSize:15];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.text=mtitle;
    titlelabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:titlelabel];
    
    mY=mY+titlelabel.frame.size.height;
    
    if (imagearray!=nil) {
        [imagearray removeAllObjects];
    }else
    {
        imagearray=[NSMutableArray array];
    }
    CGFloat imageS=20;//图标大小
    CGFloat mMargin=20;//左右的间距
    CGFloat RadioW=mW-mMargin*2-imageS-5;//40为左右margin 20为左边图标的空位
    UIFont *mfont = [UIFont systemFontOfSize:15];
    CGFloat minH=[self frameWithText:@"1" andWidth:RadioW withFont:mfont]*2-1;//最小高度
    for (int i=0; i<array.count; i++) {
        // 初始化label
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
           
        NSString* mStr=array[i];;

        // label获取字体
        label.font = mfont;
        label.textColor=[UIColor blackColor];
        // 根据获取到的字符串以及字体计算label需要的size
        CGFloat sizeH=[self frameWithText:mStr andWidth:RadioW withFont:mfont];
        
        //最小高度限制
        if (sizeH<minH) {
            sizeH=minH;
        }
        //CGSize size = [self boundingRectWithSize:CGSizeMake(RadioW, 0) AndStr:mStr AndFont:mfont];
           
        // 设置无限换行
        label.numberOfLines = 0;
           
        // 设置label的frame
        label.frame = CGRectMake(mMargin+imageS+5, mY, RadioW,sizeH);
        // label获取字符串
        label.text = mStr;
        
        
        //配置图标
        UIImageView *mimageView = [[UIImageView alloc]initWithFrame:CGRectMake(mMargin,label.frame.origin.y+label.frame.size.height/2-imageS/2, imageS, imageS)];
        //mimageView.image=[UIImage imageNamed:@"loginoff"];
        if (selecitem==i) {
            mimageView.image=[UIImage imageNamed:@"setsOn"];
        }else
        {
            mimageView.image=[UIImage imageNamed:@"setsOff"];
        }
        //mimageView.backgroundColor=[UIColor greenColor];
        
        //NSLog(@"i=%d mimageViewY=%f",i,mimageView.frame.origin.y);
        
        [self.contentView addSubview:mimageView];
        [imagearray addObject:mimageView];
        
        //配置点击事件
        UIButton *clickaction=[[UIButton alloc]initWithFrame:CGRectMake(0, mY, mW, sizeH)];
        clickaction.tag=i;
        [clickaction addTarget:self
                        action:@selector(DoClickaAtion:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:clickaction];
        
        //NSLog(@"i=%d mY=%f mH=%f",i,mY,sizeH);
        mY=mY+sizeH+10;
    }
    
    //配置左右按钮和线
    CGFloat buttonH=50;//按钮高度
    _cancelbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, mY, mW/2, buttonH)];
    _cancelbutton.titleLabel.font= [UIFont systemFontOfSize:15];;
    [_cancelbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelbutton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
    [_cancelbutton addTarget:self
                    action:@selector(DoCancelAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cancelbutton];
    
    _sendbutton=[[UIButton alloc]initWithFrame:CGRectMake(mW/2, mY, mW/2, buttonH)];
    _sendbutton.titleLabel.font= [UIFont systemFontOfSize:15];;
    [_sendbutton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_sendbutton setTitle:[SwichLanguage getString:@"sure"] forState:UIControlStateNormal];
    [_sendbutton addTarget:self
                    action:@selector(DoSendAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_sendbutton];
    
    //灰色T形分割线
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, mY-1, mW, 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
    [self.contentView addSubview:line1];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(mW/2-0.5, mY, 1, buttonH)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
    [self.contentView addSubview:line2];
    
    //最后适配content高度
    CGRect mcontent=self.contentView.frame;
    mcontent.size.height=CGRectGetMaxY(_sendbutton.frame);
    [self.contentView setFrame:mcontent];
    
    [self.contentView setCenter:CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2)];
}
// 根据字符串的长度以及宽度来获取字符串的高度。
- (CGFloat)frameWithText:(NSString *)string andWidth:(CGFloat )width withFont:(UIFont*)tfont

{

    CGSize size = CGSizeMake(width, MAXFLOAT);//最大范围


    NSDictionary *tdic = [NSDictionary dictionaryWithObject:tfont forKey:NSFontAttributeName];

    CGSize textSize = [string boundingRectWithSize:size

                                           options:NSStringDrawingUsesLineFragmentOrigin

                                        attributes:tdic

                                           context:nil].size;

    CGFloat height = ceilf(textSize.height) + 1;

    return height;

}
//动态获取高度
- (CGSize)boundingRectWithSize:(CGSize)size AndStr:(NSString*)mStr AndFont:(UIFont*)mfont
{
     NSDictionary *attribute = @{NSFontAttributeName: mfont};
     CGSize retSize = [mStr boundingRectWithSize:size
                                              options:\
                                                      NSStringDrawingTruncatesLastVisibleLine |
                                                      NSStringDrawingUsesLineFragmentOrigin |
                                                        NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil
                      ].size;
      return retSize;
 }


- (void)dismissThePopView{
    
    if (imagearray!=nil) {
        [imagearray removeAllObjects];
        imagearray=nil;
    }
    [self removeFromSuperview];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//
//    [self dismissThePopView];
//
//
//}



-(void)DoClickaAtion:(UIButton*)mbutton
{
    NSLog(@"tag=%ld",(long)mbutton.tag);
    selecitem=(int)mbutton.tag;
    if (imagearray!=nil) {
        for (int i=0; i<imagearray.count; i++) {
            UIImageView* mimageview=[imagearray objectAtIndex:i];
            if (selecitem==i) {
                mimageview.image=[UIImage imageNamed:@"setsOn"];
            }else
            {
                mimageview.image=[UIImage imageNamed:@"setsOff"];
            }
        }
    }
}
-(void)DoCancelAction
{
    [self dismissThePopView];
}
-(void)DoSendAction
{
        if ([self.QCPopViewDelegate respondsToSelector:@selector(getTheButtonTitleWithIndexPath:)]) {
            [self.QCPopViewDelegate getTheButtonTitleWithIndexPath:selecitem];
        }
    [self dismissThePopView];
}


@end
