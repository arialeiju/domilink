//
//  SettingGridViewController.h
//  DM100
//
//  Created by 马真红 on 2021/10/8.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingGridViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *SettingGridConllection;
@property (strong,nonatomic) NSMutableArray *dataArr1;
@property (strong,nonatomic) NSMutableArray *dataArr2;
@property (strong,nonatomic) NSMutableArray *dataArr3;
@property (strong,nonatomic) NSMutableArray *imageArr1;
@property (strong,nonatomic) NSMutableArray *imageArr2;
@property (strong,nonatomic) NSMutableArray *imageArr3;
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype andImeiName:(NSString *)mImeiName;
@end

NS_ASSUME_NONNULL_END
