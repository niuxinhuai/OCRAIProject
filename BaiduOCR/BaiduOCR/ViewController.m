//
//  ViewController.m
//  BaiduOCR
//
//  Created by 牛新怀 on 2017/8/10.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ViewController.h"
#import "BaiduAIPictureIdentifyView.h"
@interface ViewController ()<PictureIdentifyDelegate,AipOcrDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong)BaiduAIPictureIdentifyView * pictureIdentifyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view, typically from a nib.
    [self initWithView];
}
- (void)initWithView{
    self.title = @"BaiduOCR";
    UIColor * color = [UIColor cyanColor];
    self.navigationController.navigationBar.barTintColor = color;
    UIColor * titleColor = [UIColor redColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};

    [self.view addSubview:self.pictureIdentifyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BaiduAIPictureIdentifyView *)pictureIdentifyView{
    if (!_pictureIdentifyView) {
        _pictureIdentifyView = [[BaiduAIPictureIdentifyView alloc]init];
        _pictureIdentifyView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        _pictureIdentifyView.backgroundColor = [UIColor cyanColor];
        _pictureIdentifyView.delegate = self;
        
    }
    
    return _pictureIdentifyView;
}
#pragma mark - PictureIdentifyDelegate
- (void)baiduAiViewClassNameView:(BaiduAIPictureIdentifyView *)view withCardType:(AVCaptureDeviceCardType)type{
    switch (type) {
        case AVCaptureDeviceCardTypeIdCardFont:
        {
            [self idcardOCROnline];
            break;
        }
        case AVCaptureDeviceCardTypeIdCardBack:
        {
            [self idcardOCRBackOnline];
            break;
        }
        case AVCaptureDeviceCardTypeBackCard:
        {
            [self bankCardOCROnline];
            break;
        }
        case AVCaptureDeviceCardTypeCarCard:
        {
            [self controllerButtonSelectSourceType:AVCaptureDeviceCardTypeCarCard];
            break;
        }
        case AVCaptureDeviceCardTypeFaceProfileAudit:
        {
            [self controllerButtonSelectSourceType:AVCaptureDeviceCardTypeFaceProfileAudit];
            break;
        }
        default:
            break;
    }
}
- (void)controllerButtonSelectSourceType:(AVCaptureDeviceCardType)type{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//是否可以编辑
    
    //打开相机
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            image = [NetWorkTool resizeImage:image];
            self.pictureIdentifyView.imageNamed = image;

            [self carCardWithImage:image];
            
        }
    }];
}

#pragma mark - 机动车车牌号识别 / 用户头像审核
- (void)carCardWithImage:(UIImage *)image{
    switch (self.pictureIdentifyView.card_type) {
        case AVCaptureDeviceCardTypeCarCard:
        {
            [NetWorkTool postNetWorkWithImage:image types:CardTypeCarCard withURL:nil paramaters:nil success:^(id object) {
                NSLog(@"%@",object);
                [self ocrOnCarCardSuccessful:object];
                
            } failure:^(id failure) {
                
                [self ocrOnFail:failure];
            }];
            break;
        }
        case AVCaptureDeviceCardTypeFaceProfileAudit:
        {
            [NetWorkTool postNetWorkWithImage:image types:CardTypeFaceProfileAudit withURL:nil paramaters:nil success:^(id object) {
                NSLog(@"%@",object);
                [self ocrOnFaceProplieAutie:object];
                
            } failure:^(id failure) {
                
                [self ocrOnFail:failure];
            }];
            break;
        }
        default:
            break;
    }
    
}



#pragma mark - 银行卡识别
- (void)bankCardOCROnline{
    
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证正面识别
- (void)idcardOCROnline {
    
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 身份证反面识别
- (void)idcardOCRBackOnline{
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)ocrOnFaceProplieAutie:(id)result{
    // NSString *msg = [NSString stringWithFormat:@"%@", result];
    NSMutableString *message = [NSMutableString string];
    NSArray * array1 = result[@"result"];
    NSDictionary * dic = array1[0];
    
    NSArray * array = dic[@"data"][@"ocr"][@"words_result"];
    for (int idx =0; idx<array.count; idx++) {
        NSDictionary * dic = array[idx];
        [message appendFormat:@"图片内容: %@\n", dic[@"words"]];
        
    }
    
    // [message appendFormat:@"图片内容：%@\n", result[@"words_result"][@"color"]];
    [message appendFormat:@"其他信息：%@\n", dic[@"data"][@"face"][@"result"][0]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"用户头像审核" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}


- (void)ocrOnCarCardSuccessful:(id)result{
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    title = @"机动车车牌信息";
    //    [message appendFormat:@"%@", result[@"result"]];
    [message appendFormat:@"颜色：%@\n", result[@"words_result"][@"color"]];
    [message appendFormat:@"车牌号：%@\n", result[@"words_result"][@"number"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)ocrOnBankCardSuccessful:(id)result {
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    title = @"银行卡信息";
    //    [message appendFormat:@"%@", result[@"result"]];
    [message appendFormat:@"卡号：%@\n", result[@"result"][@"bank_card_number"]];
    [message appendFormat:@"类型：%@\n", result[@"result"][@"bank_card_type"]];
    [message appendFormat:@"发卡行：%@\n", result[@"result"][@"bank_name"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)ocrOnFail:(id)error {
    NSLog(@"%@", error);
    NSString *msg = [NSString stringWithFormat:@"%@", error];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

- (void)ocrOnIdCardSuccessful:(id)result {
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    NSDictionary *dic = result[@"words_result"];
    if(dic&&dic.count >0){
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"保存图片",nil];
        alertView.tag = 255;
        [alertView show];
    }];
}

@end
