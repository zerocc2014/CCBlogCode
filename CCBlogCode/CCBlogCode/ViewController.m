//
//  ViewController.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/01.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import "ViewController.h"
#import "CCThreadVC.h"
#import "CCBSDSocketVC.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *sourceArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sourceArray = @[@"多线程", @"属性修饰词相关", @"Socket 编程"];
    
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
    
    cell.textLabel.text = _sourceArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row == 0) {
        CCThreadVC *threadVc = [[CCThreadVC alloc] init];
        [self.navigationController pushViewController:threadVc animated:YES];
    }else if (indexPath.row == 1) {
        
    }else if (indexPath.row == 2) {
        CCBSDSocketVC *threadVc = [[CCBSDSocketVC alloc] init];
        [self.navigationController pushViewController:threadVc animated:YES];
    }else {
        
    }
}


@end
