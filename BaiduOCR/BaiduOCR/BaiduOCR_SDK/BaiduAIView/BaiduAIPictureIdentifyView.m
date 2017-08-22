//
//  BaiduAIPictureIdentifyView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/4.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#define LabelTitleFont [UIFont systemFontOfSize:16]
#import "BaiduAIPictureIdentifyView.h"

@interface BaiduAIPictureIdentifyView()
@property (strong, nonatomic) UIView * topLineView;
@property (strong, nonatomic) UIView * bgView;
@property (strong, nonatomic) UILabel * topTitleLabel;
@property (strong, nonatomic) UILabel * descriptionLabel;
@property (strong, nonatomic) UIImageView * bgImageView;
@property (strong, nonatomic) UIButton * bottomButton;
@end
@implementation BaiduAIPictureIdentifyView
+(instancetype)shareInstanceView{
    static id view;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        view = [[BaiduAIPictureIdentifyView alloc]init];
        
    });
    return view;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self addChildView];
    [self layoutWithRect];
    

}
- (void)addChildView{
    [self addSubview:self.topLineView];
    [self addSubview:self.bgView];
    [self addSubview:self.bottomButton];
}
- (void)layoutWithRect{
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(50*OffHeight));
        
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLineView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(300*OffHeight));
        
    }];
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.topLineView.center);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@(30*OffHeight));
        
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView.center);
        make.width.mas_equalTo(self.bgView.mas_width).offset(-40);
        make.height.mas_equalTo(@(80*OffHeight));
        
    }];
    

    
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(10);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@(40*OffHeight));
        
    }];
    
    
}
- (void)setImageNamed:(UIImage *)imageNamed{
    _imageNamed = imageNamed;
    if (!_imageNamed) {
        return;
    }
     [self.bgView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(self.bgView.mas_height);
        
    }];
    self.bgImageView.image = _imageNamed;
    self.bgImageView.hidden = NO;
    
    
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = [UIColor blackColor];
        _topLineView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chousePictureClick)];
        [_topLineView addGestureRecognizer:tap];
        [_topLineView addSubview:self.topTitleLabel];
    }
    
    return _topLineView;
}

- (UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]init];
        _topTitleLabel.font = LabelTitleFont;
        _topTitleLabel.textColor = [UIColor whiteColor];
        _topTitleLabel.text = @"请选择图片";
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topTitleLabel;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        
        [_bgView addSubview:self.descriptionLabel];
       
    }
    
    return _bgView;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.font = LabelTitleFont;
        _descriptionLabel.text = @"注意：图片必须清晰，且背景色最好为纯色方便百度AI识别图片信息";
        _descriptionLabel.textColor = [UIColor blackColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.numberOfLines = 0;
    }
    
    
    return _descriptionLabel;
    
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}

- (UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomButton setTitle:@"清空图片" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomButton.backgroundColor = [UIColor blackColor];
        [_bottomButton addTarget:self action:@selector(dissMissImageView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}
#pragma mark - 用户点击选择图片操作
- (void)chousePictureClick{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"百度AI" message:@"请先选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"身份证正面拍照识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.card_type = AVCaptureDeviceCardTypeIdCardFont;
        [self.delegate baiduAiViewClassNameView:self withCardType:AVCaptureDeviceCardTypeIdCardFont];
        
    }];
    UIAlertAction * confirmActions = [UIAlertAction actionWithTitle:@"身份证反面拍照识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.card_type = AVCaptureDeviceCardTypeBackCard;
         [self.delegate baiduAiViewClassNameView:self withCardType:AVCaptureDeviceCardTypeBackCard];
    }];
    UIAlertAction * confirmAction1 = [UIAlertAction actionWithTitle:@"银行卡正面拍照识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.card_type = AVCaptureDeviceCardTypeBackCard;
        [self.delegate baiduAiViewClassNameView:self withCardType:AVCaptureDeviceCardTypeBackCard];
    }];
    UIAlertAction * confirmAction2 = [UIAlertAction actionWithTitle:@"机动车车牌识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.card_type = AVCaptureDeviceCardTypeCarCard;
        [self.delegate baiduAiViewClassNameView:self withCardType:AVCaptureDeviceCardTypeCarCard];
    }];
    
    UIAlertAction * confirmAction3 = [UIAlertAction actionWithTitle:@"图文识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.card_type = AVCaptureDeviceCardTypeFaceProfileAudit;
        [self.delegate baiduAiViewClassNameView:self withCardType:AVCaptureDeviceCardTypeFaceProfileAudit];
    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    [cancleAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    [controller addAction:cancleAction];
    [controller addAction:confirmAction];
    [controller addAction:confirmActions];
    [controller addAction:confirmAction1];
    [controller addAction:confirmAction2];
    [controller addAction:confirmAction3];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
    
}
#pragma mark - 清空图片
- (void)dissMissImageView{
    if (_imageNamed) {
        self.bgImageView.image = nil;
        self.bgImageView.hidden = YES;
        [self.bgImageView removeFromSuperview];
    }
}
@end
