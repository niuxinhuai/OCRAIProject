//
//  BaiduAIPictureIdentifyView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/4.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AVCaptureDeviceCardType){
    AVCaptureDeviceCardTypeIdCardFont = 0,// 身份证正面识别
    AVCaptureDeviceCardTypeIdCardBack,// 身份证背面识别
    AVCaptureDeviceCardTypeBackCard,// 银行卡识别
    AVCaptureDeviceCardTypeCarCard,//机动车车牌识别
    AVCaptureDeviceCardTypeFaceProfileAudit//用户头像审核
    
};
@class BaiduAIPictureIdentifyView;
@protocol PictureIdentifyDelegate <NSObject>
- (void)baiduAiViewClassNameView:(BaiduAIPictureIdentifyView *)view withCardType:(AVCaptureDeviceCardType)type;


@end
@interface BaiduAIPictureIdentifyView : UIView
@property (weak, nonatomic)id<PictureIdentifyDelegate>delegate;
@property (assign, nonatomic)AVCaptureDeviceCardType card_type;
+ (instancetype)shareInstanceView;
@property (strong, nonatomic)UIImage * imageNamed;
@end
