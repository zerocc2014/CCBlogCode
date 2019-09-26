//
//  CCEncryptVC.m
//  CCBlogCode
//
//  Created by zerocc on 2015/11/19.
//  Copyright © 2015年 zerocc. All rights reserved.
//

/*
 框架:
 SecKeyEncrypt 公钥对数据加密
 SecKeyDecrypt 私钥对数据解密
 SecKeyRawVerify 公钥对数字签名进行验证
 SecKeyRawSign 私钥生成数字签名
 
 加密算法分类：
 1. 对称加密算法：加密解密都使用相同的密钥，速度快，适合大数据加密，方法有 DES、3DES、AES等。
 2. 非对称加密算法：需要两个密钥一个公开密钥(publickey)和一个私有密钥(privatekey)；
                 可逆的加密算法，用公钥加密，用私钥解密，用私钥加密，用公钥解密；
                 速度慢，适合对小数据加密，方法有RSA。
 3. 散列算法：加密后不能解密是不可逆的，算法公开，对相同的数据加密得到的结果是一样的；
            对不同的数据加密，得到的结果是定长的，不能返算；
            又叫哈希函数、信息指纹，信息摘要 - 用来做数据识别；
            方法有 MD5、SHA1、SHA256、SHA512、HMAC。
 
 公钥、私钥:
 1. 创建私钥: 生成安全强度是512（或者1024）的RAS私钥 .pem 证书文件, 其是 base64 的格式；
            openssl genrsa -out private.pem 512
 2. 生成证书请求文件：是 .csr 文件；
                  openssl req -new -key private.pem -out rsacert.csr
 3. 签名: 证书颁发机构签名，证明证书合法有效的，生成一个.crt 的一个 base64 公钥文件,
         也可以自签名一个证书, 生成证书并签名，有效期10年，
         openssl x509 -req -days 3650 -in rsacert.csr -signkey private.pem -out rsacert.crt
        备注iOS开发时使用的时候不能是base64的，必须解成二进制文件。
 4. 解成.der公钥二进制文件，放程序做加密用
    openssl x509 -outform der -in rsacert.crt -out rsacert.der
 5. 生成.p12二进制私钥文件：.pem 是base64的不能直接使用，必须导成.p12信息交换文件用来传递秘钥
    openssl pkcs12 -export -out p.p12 -inkey private.pem -in rsacert.crt
 */

#import "CCEncryptVC.h"
#import "CCEncrypt.h"

@interface CCEncryptVC ()

@end

@implementation CCEncryptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self testRSA];
}

- (void)testRSA {
    CCEncrypt *encrypt = [[CCEncrypt alloc] init];
    // 1. 加载公钥
    NSString *pubPath = [[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil];
    [encrypt loadPublicKeyWithFilePath:pubPath];
    
    // 2. 使用公钥加密
    NSString *result = [encrypt RSAEncryptString:@"123456jkkkhhh"];
    NSLog(@"加密之后的结果是:%@",result);
    
    // 3. 加载私钥,并且指定导出p12时设定的密码
    NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil];
    [encrypt loadPrivateKey:privatePath password:@"123456"];
    
    // 4. 使用私钥解密
    NSLog(@"解密结果 %@", [encrypt RSADecryptString:result]);
}


@end
