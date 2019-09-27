//
//  CCTabBarController.m
//  CC_Summary_2016
//
//  Created by zerocc on 2016/03/25.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCTabBarController.h"
#import "CCNavigationController.h"
#import "CCObjcVC.h"
#import "CCThirdPartyAnalyzeVC.h"
#import "CCKitVC.h"
#import "CCAlgorithmVC.h"

@interface CCTabBarController ()

@end

@implementation CCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置子控制器
    [self addChildController];
    
    // 创建自定义tabbar 更换系统自带的tabbar KVC
    [self addCustomTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addCustomTabBar {
    
}

- (void)addChildController {
    CCObjcVC *objcVc = [[CCObjcVC alloc] init];
    [self addOneChlildVc:objcVc
                   title:@"Objc"
               imageName:@"tabbar_home"
       selectedImageName:@"tabbar_home_selected"];
    
    CCThirdPartyAnalyzeVC *analyzeVC = [[CCThirdPartyAnalyzeVC alloc] init];
    [self addOneChlildVc:analyzeVC
                   title:@"Analyze"
               imageName:@"tabbar_home"
       selectedImageName:@"tabbar_home_selected"];
    
    CCKitVC *kitVc = [[CCKitVC alloc] init];
    [self addOneChlildVc:kitVc
                   title:@"CCKit"
               imageName:@"tabbar_home"
       selectedImageName:@"tabbar_home_selected"];

    CCAlgorithmVC *algorithmVc = [[CCAlgorithmVC alloc] init];
    [self addOneChlildVc:algorithmVc
                   title:@"Algorithm"
               imageName:@"tabbar_home"
       selectedImageName:@"tabbar_home_selected"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addOneChlildVc:(UIViewController *)childVc
                 title:(NSString *)title
             imageName:(NSString *)image
     selectedImageName:(NSString *)selectedImage
{
    // 设置子控制器下文字
    childVc.title = title;  // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // imageWithRenderingMode UIImage的渲染模式
    
    // 设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor redColor];

    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor yellowColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVc.view.backgroundColor = [UIColor whiteColor];
    
    CCNavigationController *navigationController = [[CCNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navigationController];
}

@end
