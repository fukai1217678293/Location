//
//  LocationAuthorzation.m
//  Demo
//
//  Created by 付凯 on 2017/7/5.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import "LocationAuthorzation.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#ifndef kSystemVersion
#define kSystemVersion [UIDevice currentDevice].systemVersion.doubleValue
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

@interface LocationAuthorzation ()<UIAlertViewDelegate>

@end

@implementation LocationAuthorzation

static NSString *url;
static NSMutableArray *array;

+ (BOOL)locationAuthorzation {
    BOOL ret = YES;
    NSString * urlString;
    if (![CLLocationManager locationServicesEnabled]) {
        urlString = @"prefs:root=LOCATION_SERVICES";
        ret = NO;
    }
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {
        urlString = UIApplicationOpenSettingsURLString;
        ret = NO;
    }
    if (!ret) {
        if (kiOS8Later) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未打开定位权限,是否打开？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"不打开" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }]];
            UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
            [rootWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            url = urlString;
            LocationAuthorzation * selfObj = [self new];
            [[self objArray] addObject:selfObj];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未打开定位权限,是否打开？" delegate:selfObj cancelButtonTitle:@"不打开" otherButtonTitles:@"去打开", nil];
            [alert show];
#pragma clang diagnostic pop
        }
        
    }
    return ret;    
}
+ (NSMutableArray *)objArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!array) {
            array = [NSMutableArray array];
        }
    });
    return array;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    [[[self class] objArray] removeObject:self];
}

@end
