//
//  CCBSDSocketServerVC.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import "CCBSDSocketServerVC.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface CCBSDSocketServerVC ()
@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UITextField *msgTextField;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextView *receiveTextView;

@property (nonatomic, strong) NSMutableAttributedString *receiveTextViewAttributeStr;
@property (nonatomic, assign) int socketID;
@property (nonatomic, assign) int client_socket;

@end

@implementation CCBSDSocketServerVC

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
    
    if (_socketID == -1) {
        NSLog(@"服务端创建 socket 失败");
        return;
    }
    NSLog(@"服务端创建 socket 成功");
    
    // 2. 绑定socket
    struct in_addr  socketIn_addr;
    socketIn_addr.s_addr = inet_addr("127.0.0.1");
    struct sockaddr_in socketAddr;
    socketAddr.sin_family = AF_INET;
    socketAddr.sin_port = htons(8029);
    socketAddr.sin_addr = socketIn_addr;
    // 置字节字符串socketAddr.sin_zero的前8个字节为零, 无返回值
    bzero(&(socketAddr.sin_zero), 8);
    
    int bind_result = bind(self.socketID, (const struct sockaddr *)&socketAddr, sizeof(socketAddr));
    if (bind_result == -1) {
        NSLog(@"服务端绑定 socket 失败");
        return;
    }
    NSLog(@"服务端绑定 socket成功");
    
    // 3. 监听socket
    int listen_result = listen(self.socketID, 5);
    if (listen_result == -1) {
        NSLog(@"服务端监听失败");
        return;
    }
    NSLog(@"服务端监听成功");
    
    // 4. 接受客户端的链接
    for (int i = 0; i < 5; i++) {
        [self acceptClientConnet];
    }

}

- (void)acceptClientConnet{
    
    // 阻塞线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        struct sockaddr_in client_address;
        socklen_t address_len;
        // accept函数
        int client_socket = accept(self.socketID, (struct sockaddr *)&client_address, &address_len);
        self.client_socket = client_socket;
        
        if (client_socket == -1) {
            NSLog(@"服务端接受 %u 客户端错误",address_len);
            
        }else{
            NSString *acceptInfo = [NSString stringWithFormat:@"客户端 in,socket:%d",client_socket];
            NSLog(@"%@",acceptInfo);
            [self receiveMsgWithClietnSocket:client_socket];
        }
        
    });
    
}

- (void)receiveMsgWithClietnSocket:(int)clientSocket{
    while (1) {
        // 5. 接收客户端传来的数据
        char buf[1024] = {0};
        long iReturn = recv(clientSocket, buf, 1024, 0);
        if (iReturn>0) {
            // 接收到的数据转换
            NSData *receiveData  = [NSData dataWithBytes:buf length:iReturn];
            NSString *receiveStr = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            NSLog(@"服务端来接收了%@",receiveStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsg:receiveStr msgType:0];
            });
        }else if (iReturn == -1){
            NSLog(@"服务端读取消息失败");
            break;
        }else if (iReturn == 0){
            NSLog(@"客户端走了");
            
            close(clientSocket);
            break;
        }
    }
}

- (void)sendBtnClicked {
    const char *msg = self.msgTextField.text.UTF8String;
    // 6. 服务端发送数据
    ssize_t sendLength = send(self.client_socket, msg, strlen(msg), 0);
    NSLog(@"服务端发送了:%ld字节 \n %@",sendLength, self.msgTextField.text);
    [self showMsg:self.msgTextField.text msgType:1];
    self.msgTextField.text = @"";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 7. 断开连接
    if (self.socketID) {
        close(_socketID);
        [self.connectBtn setTitle:@"连接" forState:UIControlStateNormal];
    }
}

- (void)showMsg:(NSString *)msg msgType:(int)msgType{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20.f;
    NSMutableAttributedString *attributedString;
    if (msgType == 0) { // 客户端的消息
        attributedString = [[NSMutableAttributedString alloc] initWithString:msg];
        paragraphStyle.alignment = NSTextAlignmentRight;
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                          NSForegroundColorAttributeName:[UIColor whiteColor],
                                          NSBackgroundColorAttributeName:[UIColor blueColor],
                                          NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, msg.length)];
    }else { // 服务端的消息
        attributedString = [[NSMutableAttributedString alloc] initWithString:msg];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                          NSForegroundColorAttributeName:[UIColor blackColor],
                                          NSBackgroundColorAttributeName:[UIColor whiteColor],
                                          NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, msg.length)];
    }
    [self.receiveTextViewAttributeStr appendAttributedString:attributedString];
    [self.receiveTextViewAttributeStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n\n"]];
    self.receiveTextView.attributedText = self.receiveTextViewAttributeStr;
}

@end
