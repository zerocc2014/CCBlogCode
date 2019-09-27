//
//  CCObjcVC.m
//  ObjcCode
//
//  Created by zerocc on 2019/9/26.
//  Copyright © 2019 zerocc. All rights reserved.
//

#import "CCObjcVC.h"

@interface CCObjcVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *sourceArray;


@end

@implementation CCObjcVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sourceArray = @[@{@"title":@"临时调试demo",
                       @"class":@"CCTempDemoVC"}];
    
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
