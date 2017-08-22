//
//  NetWorkTool.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/3.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AipCaptureCardVC.h"
@interface NetWorkTool : NSObject
+ (void)postNetWorkWithURL:(NSString *)url paramaters:(NSMutableDictionary *)paramatersDictionary success:(void(^)(id object))success failure:(void(^)(id failure))failure;

// 增加图片识别通用接口

+ (void)postNetWorkWithImage:(UIImage *)image types:(CardType)types withURL:(NSString *)url paramaters:(NSMutableDictionary *)paramaters success:(void(^)(id object))success failure:(void(^)(id failure))failure;

+(UIImage *)resizeImage:(UIImage *)image;
@end
