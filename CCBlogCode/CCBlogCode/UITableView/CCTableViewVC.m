//
//  CCTableViewVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/3/6.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCTableViewVC.h"

@interface CCTableViewVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *sourceArray;

@end

@implementation CCTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sourceArray = @[@{@"title":@"UITableView 的常规使用",
                       @"class":@"CCCommonTableViewVC"},
                     @{@"title":@"BSDSocket 服务端示例",
                       @"class":@"CCBSDSocketServerVC"},
                     @{@"title":@"GCDAsyncSocket 客户端示例",
                       @"class":@"CCGCDAsyncSocketVC"}];
    [self setupUI];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    cell.textLabel.text = [tmpDic objectForKey:@"title"];
    
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
