//
//  BMKGeoCodeService.m
//  Demo
//
//  Created by 付凯 on 2017/7/5.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import "BMKGeoCodeService.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface BMKGeoCodeService ()<BMKGeoCodeSearchDelegate>

@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,copy)ReverseGeoCodeCompletionBlock reverseCompletionBlock;

@end

@implementation BMKGeoCodeService

static NSMutableArray *_objArray;

#pragma mark - public method
+ (void)startReverseGeoCodeServiceWithLocation:(CLLocation *)location completionBlock:(ReverseGeoCodeCompletionBlock)completion {
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = location.coordinate;
    BMKGeoCodeService *service = [BMKGeoCodeService manager];
    service.reverseCompletionBlock = completion;
    [service.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    [[self objArray] addObject:service];
}
#pragma mark - private method
+ (instancetype)manager {
    return [[self alloc] init];
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
        self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        self.geoCodeSearch.delegate = self;
    }
    return self;
}
- (void)reDealloc {
    self.reverseCompletionBlock = nil;
    self.geoCodeSearch.delegate = nil;
    self.geoCodeSearch = nil;
    [[[self class] objArray] removeObject:self];
}
#pragma mark -BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error {
    if (self.reverseCompletionBlock) {
        if (error != BMK_SEARCH_NO_ERROR) {
            NSError *sysError = [NSError errorWithDomain:@"" code:error userInfo:nil];
            self.reverseCompletionBlock(result, sysError);
        } else{
            self.reverseCompletionBlock(result, nil);
        }
    }
    [self reDealloc];
}

@end
