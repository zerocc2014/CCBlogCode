//
//  CCBSDSocketClientVC.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import "CCBSDSocketClientVC.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface CCBSDSocketClientVC ()
@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UITextField *msgTextField;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextView *receiveTextView;

@property (nonatomic, strong) NSMutableAttributedString *receiveTextViewAttributeStr;
@property (nonatomic, assign) int socketID;

@end

@implementation CCBSDSocketClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.connectBtn.frame = CGRectMake(100, 64+20, 100, 40);
    self.connectBtn.backgroundColor = [UIColor redColor];
    [self.connectBtn setTitle:@"连接" forState:UIControlStateNormal];
    [self.connectBtn addTarget:self action:@selector(connectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.connectBtn];
    
    self.msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 140, 200, 30)];
    self.msgTextField.font = [UIFont systemFontOfSize:14];
    self.msgTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.msgTextField];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(250, 140, 60, 30);
    self.sendBtn.backgroundColor = [UIColor redColor];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendBtn];
    
    self.receiveTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 200, 300, 300)];
    self.receiveTextView.scrollEnabled = YES;
    self.receiveTextView.editable = NO;
    self.receiveTextView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.receiveTextView];
    self.receiveTextViewAttributeStr = [[NSMutableAttributedString alloc] init];
}

- (void)connectBtnClicked {
    // 1. 创建socket
    _socketID = socket(AF_INET, SOCK_STREAM, 0);
    
    // 2. 建立连接
    struct in_addr  socketIn_addr;
    socketIn_addr.s_addr = inet_addr("127.0.0.1");
    struct sockaddr_in socketAddr;
    socketAddr.sin_family = AF_INET;
    socketAddr.sin_port = htons(8029);
    socketAddr.sin_addr = socketIn_addr;
    
    int result = connect(_socketID, (const struct sockaddr *)&socketAddr, sizeof(socketAddr));
    if (result == 0) {
        NSLog(@"socket 客户端连接成功");
        [self.connectBtn setTitle:@"连接成功" forState:UIControlStateNormal];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self receiveMessage];
        });
    }else {
        NSLog(@"socket 客户端连接失败");
    }
}

- (void)sendBtnClicked {
    const char *msg = self.msgTextField.text.UTF8String;
    // 3. 发送数据
    ssize_t sendLength = send(self.socketID, msg, strlen(msg), 0);
    NSLog(@"客户端发送了:%ld字节 \n %@",sendLength, self.msgTextField.text);
    [self showMsg:self.msgTextField.text msgType:0];
    self.msgTextField.text = @"";
}

- (void)receiveMessage {
    while (1) {
        uint8_t buffer[1024];
        // 4. 接收数据
        ssize_t receiveLength = recv(self.socketID, buffer, sizeof(buffer), 0);
        if (receiveLength > 0) {
            NSData *receiveData  = [NSData dataWithBytes:buffer length:receiveLength];
            NSString *receiveStr = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            NSLog(@"客户端接收了:%ld字节 \n %@",receiveLength, receiveStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsg:receiveStr msgType:1];
            });
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 5. 断开连接
    if (self.socketID) {
        close(_socketID);
        [self.connectBtn setTitle:@"连接" forState:UIControlStateNormal];
    }
}

- (void)showMsg:(NSString *)msg msgType:(int)msgType{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20.f;
    NSMutableAttributedString *attributedString;
    if (msgType == 0) { // 我发送的
        attributedString = [[NSMutableAttributedString alloc] initWithString:msg];
        paragraphStyle.alignment = NSTextAlignmentRight;
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                          NSBackgroundColorAttributeName:[UIColor blueColor],
                                          NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, msg.length)];
        [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
    }else { // 接收到的
        attributedString = [[NSMutableAttributedString alloc] initWithString:msg];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                          NSForegroundColorAttributeName:[UIColor blackColor],
                                          NSBackgroundColorAttributeName:[UIColor whiteColor],
                                          NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, msg.length)];
    }
    [self.receiveTextViewAttributeStr appendAttributedString:attributedString];
    [self.receiveTextViewAttributeStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
    self.receiveTextView.attributedText = self.receiveTextViewAttributeStr;
}


@end
