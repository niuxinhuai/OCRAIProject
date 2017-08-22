//
//  AipCaptureCardVC.h
//  OCRLib
//  卡片识别VewController
//  Created by Yan,Xiangda on 16/11/9.
//  Copyright © 2016年 Baidu Passport. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AipOcrSdk/AipOcrDelegate.h>
#import "AipOcrDelegate.h"

typedef NS_ENUM(NSInteger, CardType) {
    
    CardTypeIdCardFont = 0,
    CardTypeIdCardBack,
    CardTypeBankCard,
    CardTypeLocalIdCardFont ,
    CardTypeLocalIdCardBack,
    CardTypeLocalBankCard,
    CardTypeCarCard,
    CardTypeFaceProfileAudit//用户头像审核
};

@interface AipCaptureCardVC : UIViewController

@property (nonatomic, assign) CardType cardType;
@property (nonatomic, weak) id<AipOcrDelegate> delegate;

+(UIViewController *)ViewControllerWithCardType:(CardType)type andDelegate:(id<AipOcrDelegate>)delegate;

@end
