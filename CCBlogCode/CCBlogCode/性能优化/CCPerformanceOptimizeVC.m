//
//  CCPerformanceOptimizeVC.m
//  CCBlogCode
//
//  Created by zerocc on 2019/9/11.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCPerformanceOptimizeVC.h"

@interface CCPerformanceOptimizeVC ()

@end

@implementation CCPerformanceOptimizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 圆角裁剪
- (void)test0 {
    // masksToBounds + cornerRadius 导致离屏渲染 ios 9.0之后做了优化不会触发UIButton还会
    UIImageView *imageView1 = [UIImageView new];
    imageView1.image = [UIImage imageNamed:@"aa"];
    imageView1.layer.cornerRadius  = imageView1.frame.size.width / 2;
    imageView1.layer.masksToBounds = YES;
    
    // 使用贝塞尔曲线 UIBezierPath 和 Core Graphics框架画出一个圆角
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView2.image = [UIImage imageNamed:@"1"];
    //开始对imageView进行画图 UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView2.bounds
                                cornerRadius:imageView2.frame.size.width] addClip];
    [imageView2 drawRect:imageView2.bounds];
    imageView2.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画图
    UIGraphicsEndImageContext(); [self.view addSubview:imageView2];
    
    // 使用CAShapeLayer和UIBezierPath设置圆角
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView3.image = [UIImage imageNamed:@"1"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView3.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView3.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView3.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView3.layer.mask = maskLayer;
    
    /*
     1. iOS 9.0 之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了，如果设置其他阴影效果之类的还是会触发离屏渲染的
     2. drawRect（继承于CoreGraphics走的是CPU,消耗的性能较大）;
     3. CAShapeLayer动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况
     */
    
//  wwwwwwwww
    
    
}


@end
