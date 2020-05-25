//
//  MessageCenterObject.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/24.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCenterObject : NSObject

@property (strong, nonatomic)NSString * pagesize;
@property (strong, nonatomic)NSString * pageno;
@property (strong, nonatomic)NSMutableArray * msg;

@end
