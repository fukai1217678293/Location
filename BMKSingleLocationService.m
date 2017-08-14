//
//  BMKSingleLocationService.m
//  Demo
//
//  Created by 付凯 on 2017/7/5.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import "BMKSingleLocationService.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "LocationAuthorzation.h"

static NSMutableArray *_objArray = nil;

@interface BMKSingleLocationService ()<BMKLocationServiceDelegate>

@property (nonatomic,strong)BMKLocationService *locationService;
@property (nonatomic,assign)BOOL didLocated;
@property (nonatomic,copy) SingleLoctionCompletionBlock completionBlock;
@end

@implementation BMKSingleLocationService

#pragma mark - public method
+ (void)startLocationWithCompletionBlock:(SingleLoctionCompletionBlock)completion {
    if ([LocationAuthorzation locationAuthorzation]) {
        BMKSingleLocationService * singleLocationService = [BMKSingleLocationService manager];
        singleLocationService.completionBlock = completion;
        [singleLocationService.locationService startUserLocationService];
        [[self objArray] addObject:singleLocationService];
    }
}

#pragma mark - private method
+ (instancetype)manager {
    return [[[self class] alloc] init];
}
+ (NSMutableArray *)objArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_objArray) {
            _objArray = [NSMutableArray array];
        }
    });
    return _objArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.didLocated = NO;//didUpdateBMKUserLocation 在stop后，由于延迟等原因，会再次调用，用bool来控制
        self.locationService = [[BMKLocationService alloc] init];
        //设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
        _locationService.distanceFilter = 200;
        //设定定位精度
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        //设置代理
        _locationService.delegate = self;
    }
    return self;
}
- (void)reDealloc {
    self.completionBlock = nil;
    [self.locationService stopUserLocationService];
    self.locationService.delegate = nil;
    self.locationService = nil;
    [[[self class] objArray] removeObject:self];
}
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (!self.didLocated) {
        if (userLocation.location) {//location是否为nil
            self.didLocated = YES;
            if (self.completionBlock) {
                self.completionBlock(userLocation.location, nil);
            }
            [self reDealloc];
        }
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error {
    if (!self.didLocated) {
        self.didLocated = YES;
        if (self.completionBlock) {
            self.completionBlock(nil, error);
        }
    }
    [self reDealloc];
}

@end
