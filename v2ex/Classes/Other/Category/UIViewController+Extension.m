//
//  UIViewController+Extension.m
//  v2ex
//
//  Created by gengjie on 16/8/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "MobClick.h"
#import "Masonry.h"
#import "UIImage+Extension.h"

@implementation UIViewController (Extension)

- (void)setTempNavImageView
{
    UIImageView *greeenView = [[UIImageView alloc] init];
    greeenView.image = [UIImage imageWithColor: [UIColor colorWithHexString: WTAppLightColor]];
    [self.view addSubview: greeenView];
    greeenView.frame = CGRectMake(0, 0, WTScreenWidth, 64);
}

/** 设置导航栏的背景图片 */
- (void)setNavBackgroundImage
{
//    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageWithColor: [UIColor colorWithHexString: WTAppLightColor]] forBarMetrics:UIBarMetricsDefault];
}

+ (void)load
{
    Method wt_viewWillAppear = class_getInstanceMethod(self, @selector(wt_viewWillAppear:));
    
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    Method wt_viewWillDisappear = class_getInstanceMethod(self, @selector(wt_viewWillDisappear:));
    
    Method viewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    
    method_exchangeImplementations(wt_viewWillAppear, viewWillAppear);
    
    method_exchangeImplementations(wt_viewWillDisappear, viewWillDisappear);
}

- (void)wt_viewWillAppear:(BOOL)animated
{
    [self wt_viewWillAppear: animated];
   
    self.navigationController.navigationBar.hidden = YES;
    
    if (![self isMemberOfClass: [UINavigationController class]] || ![self isMemberOfClass: [UITabBarController class]])
    {
//         WTLog(@"%@ wt_viewWillAppear", NSStringFromClass([self class]))
        [MobClick beginLogPageView: NSStringFromClass([self class])];
    }
    
    
}

- (void)wt_viewWillDisappear:(BOOL)animated
{
    [self wt_viewWillDisappear: animated];
    if (![self isMemberOfClass: [UINavigationController class]] || ![self isMemberOfClass: [UITabBarController class]])
    {
//        WTLog(@"%@ wt_viewWillDisappear", NSStringFromClass([self class]))
        [MobClick endLogPageView: NSStringFromClass([self class])];
    }
}

- (void)navViewWithTitle:(NSString *)title
{
    UIView *navView = [UIView new];
    navView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarBackgroundColor);
    [self.view addSubview: navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(64);
        make.top.left.right.offset(0);
    }];
    
    UIView *navLineView = [UIView new];
    navLineView.dk_backgroundColorPicker = DKColorPickerWithKey(UINavbarLineViewBackgroundColor);
    navLineView.alpha = 0.3;
    [navView addSubview: navLineView];
    [navLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.bottom.right.offset(0);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    self.titleLabel = titleLabel;
    titleLabel.dk_textColorPicker =  DKColorPickerWithKey(UITabBarTitleColor);
    [titleLabel sizeToFit];
    [navView addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(10);
        make.centerX.offset(0);
    }];
    
 
    UIButton *backBtn = [UIButton new];
    [backBtn setImage: [UIImage imageNamed: @"nav_back_normal"] forState: UIControlStateNormal];
    [backBtn sizeToFit];
    [navView addSubview: backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.centerY.offset(10);
    }];
}

static char *titleLabelName = "titleLabelName";

- (void)setTitleLabel:(UILabel *)titleLabel
{
    objc_setAssociatedObject(self, titleLabelName, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)titleLabel
{
    return objc_getAssociatedObject(self, titleLabelName);
}

@end
