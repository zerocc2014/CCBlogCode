//
//  ViewController.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/01.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import "ViewController.h"
#import "CCThreadVC.h"
#import "CCSocketVC.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *sourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sourceArray = @[@{@"title":@"多线程&线程锁",
                       @"class":@"CCThreadVC"},
                     @{@"title":@"属性修饰词和关键词相关",
                       @"class":@"CCPropertyKeywordVC"},
                     @{@"title":@"KVC&KVO",
                       @"class":@"CCKVOKVCVC"},
                     @{@"title":@"Socket 编程",
                       @"class":@"CCSocketVC"},
                     @{@"title":@"网络层基础",
                       @"class":@"CCNetworkVC"},
                     @{@"title":@"密码学",
                       @"class":@"CCEncryptVC"},
                     @{@"title":@"TableView 相关思考",
                       @"class":@"CCTableViewVC"},
                     @{@"title":@"RunLoop 运行循环机制",
                       @"class":@"CCRunLoopVC"},
                     @{@"title":@"事件传递和响应链",
                       @"class":@"CCTouchEventVC"},
                     @{@"title":@"Runtime 运行时机制",
                       @"class":@"CCRuntimeVC"},
                     @{@"title":@"Block 原理",
                       @"class":@"CCBlockVC"},
                     @{@"title":@"组件化架构",
                       @"class":@"CCModuleVC"},
                     @{@"title":@"临时调试demo",
                       @"class":@"CCTempDemoVC"}];
    [self setupUI];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    NSDictionary *tmpDic = _sourceArray[indexPath.row];
    NSString *title = [tmpDic objectForKey:@"title"];
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = _sourceArray[indexPath.row];
    NSString *className = [tmpDic objectForKey:@"class"];
    Class getClass = NSClassFromString(className);
    if (getClass) {
        id creatClass = [[getClass alloc] init];
        [self.navigationController pushViewController:creatClass animated:YES];
    }
    
}


@end
