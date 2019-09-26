//
//  CCGCDAsyncSocketVC.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

/*
 
 {"chargePointSerialNumber":"64564324","reqCode":8000,"param":{"chargeStatus":"Charging","ChargePointStatus":"Available"},"reqTime":1436925952}
 
 
 打包后的数据如下,16进制字符串如下
 0x86, 报文头
 0x8E,0x00 数据域长度
 0x7B,0x22,0x63,0x68,0x61,0x72,0x67,0x65,0x50,0x6F,0x69,0x6E,0x74,0x53,0x65,0x72,0x69,0x61,0x6C,0x4E,0x75,0x6D,0x62,0x65,0x72,0x22,0x3A,0x22,0x36,0x34,0x35,0x36,0x34,0x33,0x32,0x34,0x22,0x2C,0x22,0x72,0x65,0x71,0x43,0x6F,0x64,0x65,0x22,0x3A,0x38,0x30,0x30,0x30,0x2C,0x22,0x70,0x61,0x72,0x61,0x6D,0x22,0x3A,0x7B,0x22,0x63,0x68,0x61,0x72,0x67,0x65,0x53,0x74,0x61,0x74,0x75,0x73,0x22,0x3A,0x22,0x43,0x68,0x61,0x72,0x67,0x69,0x6E,0x67,0x22,0x2C,0x22,0x43,0x68,0x61,0x72,0x67,0x65,0x50,0x6F,0x69,0x6E,0x74,0x53,0x74,0x61,0x74,0x75,0x73,0x22,0x3A,0x22,0x41,0x76,0x61,0x69,0x6C,0x61,0x62,0x6C,0x65,0x22,0x7D,0x2C,0x22,0x72,0x65,0x71,0x54,0x69,0x6D,0x65,0x22,0x3A,0x31,0x34,0x33,0x36,0x39,0x32,0x35,0x39,0x35,0x32,0x7D, 数据域
 0x2A， 校验和
 00A8 报文尾
 */

#import "CCGCDAsyncSocketVC.h"
#import "GCDAsyncSocket.h"
#import "CCSocketPacket.h"

@interface CCGCDAsyncSocketVC () <GCDAsyncSocketDelegate>
@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UITextField *msgTextField;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextView *receiveTextView;

@property (nonatomic, strong) NSMutableAttributedString *receiveTextViewAttributeStr;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation CCGCDAsyncSocketVC

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
    // 1. 创建 GCDAsyncSocket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];

    // 2. 连接 socket
    NSError *error;
    [self.socket connectToHost:@"127.0.0.1" onPort:8029 error:&error];
}

- (void)sendBtnClicked {
    NSData *data = [self.msgTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. 发送消息
    // -1 永不超时；tag: 标识码用于区分业务
    [self.socket writeData:data withTimeout:-1 tag:10086];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { 
    // 4. 关闭连接
    [self.socket disconnect];
    self.socket = nil;
    
    [self testStringEncode];
}

#pragma mark - GCDAsyncSocketDelegate

// 已经连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    NSLog(@"连接成功 : %@---%d",host,port);
    [self.socket readDataWithTimeout:-1 tag:10086];
}

// 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开 socket 连接原因:%@",err);
}

//已经接收服务器返回来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"接收到tag = %ld : %lu 长度的数据",tag,(unsigned long)data.length);
    
    [self.socket readDataWithTimeout:-1 tag:10086];
}

//消息发送成功 代理函数 向服务器 发送消息
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    NSLog(@"%ld 发送数据成功",tag);
}


- (void)testStringEncode {
    NSString *str = @"zerocc我";
    // 普通字符串转 16进制字符串
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    const Byte *bytes = (Byte *)[strData bytes];
    NSString *hexStr = @"";
    for (int i = 0; i < [strData length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    NSLog(@"%@",hexStr);
    
    // 16 进制字符串转data
    unsigned long lens = [hexStr length] / 2;
    unsigned char *buf = malloc(lens);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i=0; i < [hexStr length] / 2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    NSData *messageData = [NSData dataWithBytes:buf length:lens];
    free(buf);
    
    // 拼接报文头和尾
    NSMutableData *sourceData = [[NSMutableData alloc] init];
    Byte head = 0x86;
    NSData *headData = [NSData dataWithBytes:&head length:sizeof(head)];
    Byte end = 0xA8;
    NSData *endData = [NSData dataWithBytes:&end length:sizeof(end)];
    [sourceData appendData:headData];
    [sourceData appendData:messageData];
    [sourceData appendData:endData];
    NSLog(@"%@",sourceData);
    
    NSString *strUTF8 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",strUTF8);
    // 字符串 - ASCII码 - 16 进制 - data 流
    // string - asciiString
    //    NSMutableString *asciiString = [[NSMutableString alloc] init];
    //    for (NSUInteger i=0; i<str.length; i++) {
    //        unichar asciiCode = [str characterAtIndex:i];
    //        [asciiString appendFormat:@"%hu", asciiCode];
    //    }
    //    NSLog(@"%@",asciiString);
    //
    //    // asciiString - string
    //    NSMutableString *sampleString = [[NSMutableString alloc] init];
    //    for (NSUInteger i=0; i<asciiString.length; i++) {
    //        NSString *strTemp =[NSString stringWithFormat:@"%C",asciiCode];
    //        [asciiString appendFormat:@"%hu", asciiCode];
    //    }
    
    //A
    //    NSLog(@"%hu -- %@",asciiCode,strTemp);
    

}




@end
