//
//  IAPViewController.h
//  DM100
//
//  Created by 马真红 on 2021/10/27.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface IAPViewController : UIViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>
-(id)initWithImei:(NSString *)mimei;
@end

NS_ASSUME_NONNULL_END
