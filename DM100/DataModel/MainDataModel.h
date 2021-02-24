//
//  MainDataModel.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import "PinyinDataModel.h"

@interface MainDataModel : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isExperience;

+ (instancetype) instance;

#pragma mark Format
/**
 \brief formatWithSecondes
 \details 格式化时间 00:00:00格式<p>
 \param secondes:为秒数
 \return 已格式化的时间 00:00:00
 */
-(NSString *) formatWithSeconds:(int) seconds;

/**
 \brief formatTimeSpan
 \details 格式化时间为：n秒前，n小时前，n分钟前<p>
 \param 2个NSDate的时间差
 \return 已格式化的时间
 */
-(NSString *) formatTimeSpan:(NSDate *) createdDate;

/**
 @brief     formatDurationTime
 @details   格式化时间间隔 10秒 10分钟 2小时
 @param     秒数
 @return    已格式化时间字符串
 */
- (NSString *)formatDurationTime:(int)seconds;

/**
 @brief     formatDistance
 @details   格式化距离 100米，1公里，10公里
 @param     未格式化距离（CGFloat 米）
 @return    已格式化距离 (NSString)
 */
-(NSString *) formatDistance:(CGFloat)distance;

/**
 @brief     去除html标签
 @param     html   需要剪切的字符串
 @param     trim   是否需要剪切换行
 @return    去掉标签的字符串
 */
- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

/**
 \brief scaleImage
 \details 缩小图片，注意，这里不能扩大图片<p>
 \param width:希望缩小后的宽度
 \return 缩小后的图片
 */
-(UIImage *) scaleImage:(UIImage *) sourceImage width:(double) width;


/**
 @brief 汉字拼音首字母
 @param hanzi 需要检测拼音
 @return 汉子的拼音首字母
 */
- (char)pinyinFirstLetter:(NSUInteger)hanzi;


/**
 @brief 计算文字高度
 @param width   最大宽度
 @param height  最大高度
 @param attributes  特征@{NSForegroundColorAttributeName,NSFontAttributeName}
 */
- (CGFloat)heightForText:(NSString *)text
               withWidth:(CGFloat)width
              withHeight:(CGFloat)height
      withTextAttributes:(NSDictionary *)attributes;



-(UIImage*)getImageWithStatus:(NSString*)mstatus AndCouser:(int)mcouse;
-(UIImage*)getImageWithLogoType:(NSString*)mlogoType AndStatus:(NSString*)deviceSts;

-(UIImage*)getMapImageWithStatus:(NSString*)mstatus AndCouser:(int)mcouse AndLogoType:(NSString*)mlogoType;
-(UIImage*)imageRotatedByDegrees:(NSString*)strdegrees andImage:(UIImage*)mImage;
@end
