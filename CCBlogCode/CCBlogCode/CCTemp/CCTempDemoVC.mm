//
//  CCTempDemoVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/5/4.
//  Copyright © 2017年 zerocc. All rights reserved.
//

#import "CCTempDemoVC.h"
#include <CoreFoundation/CoreFoundation.h>
#include "LinkedList1.cpp"
//#include <IOKit/IOKitLib.h>

//#import <IdentityLookup/IdentityLookup.h>

void deleteNthNodeFromEnd();

void deleteNthNodeFromEnd() {
    int arr[] = {1,2,3,5,7};
    int n = sizeof(arr)/sizeof(arr[0]);
    int k = 3;
    
    ListNode *head = Solution().createLinkedList(arr, n);
    Solution().printLinkedList(head);
    
    ListNode *newHead = Solution().deleteNthNodeFromEnd(head, k);
    Solution().printLinkedList(newHead);
}

@interface CCTempDemoVC ()

@end

@implementation CCTempDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    deleteNthNodeFromEnd();

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

//void CopySerialNumber(CFStringRef *serialNumber) {
//    if (serialNumber != NULL) {
//        *serialNumber = NULL;
//
//        io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("IOPlatformExpertDevice"));
//
//        if (platformExpert) {
//            CFTypeRef serialNumberAsCFString =
//            IORegistryEntryCreateCFProperty(platformExpert,
//                                            CFSTR(kIOPlatformSerialNumberKey),
//                                            kCFAllocatorDefault, 0);
//            if (serialNumberAsCFString) {
//                *serialNumber = serialNumberAsCFString;
//            }
//
//            IOObjectRelease(platformExpert);
//        }
//    }
//}


@end
