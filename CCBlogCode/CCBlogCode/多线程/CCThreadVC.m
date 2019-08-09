//
//  CCThreadVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/01.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCThreadVC.h"
#import "CCNSThreadVC.h"
#import "CCGCDVC.h"
#import "CCNSOperationVC.h"

#import "CCDeadLockVC.h"

#import "CCAtomicLock.h"
#import "CCCTypeLock.h"
#import "CCObjcTypeLock.h"

@interface CCThreadVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *sourceArray;


@end

@implementation CCThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _sourceArray = @[@"NSThread",@"GCD",@"NSOperation",@"DeadLock", @"AtomicLock原子操作锁", @"CTypeLock C语言锁",@"ObjcTypeLock OC 对象锁"];
    
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
    
    cell.textLabel.text = _sourceArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CCNSThreadVC *vc = [[CCNSThreadVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        CCGCDVC *vc = [[CCGCDVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        CCNSOperationVC *vc = [[CCNSOperationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
        CCDeadLockVC *vc = [[CCDeadLockVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4) {
        CCAtomicLock *vc = [[CCAtomicLock alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5) {
        CCCTypeLock *vc = [[CCCTypeLock alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6) {
        CCObjcTypeLock *vc = [[CCObjcTypeLock alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
    }

}
@end
