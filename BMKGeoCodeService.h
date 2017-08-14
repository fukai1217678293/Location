//
//  BMKGeoCodeService.h
//  Demo
//
//  Created by 付凯 on 2017/7/5.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKGeocodeType.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^ReverseGeoCodeCompletionBlock)(BMKReverseGeoCodeResult *reverseGeoCodeResult,NSError *error);
typedef void(^GeoCodeCompletionBlock)(BMKGeoCodeResult *geoCodeResult,NSError *error);

@interface BMKGeoCodeService : NSObject

+ (void)startReverseGeoCodeServiceWithLocation:(CLLocation *)location
                               completionBlock:(ReverseGeoCodeCompletionBlock)completion;

@end
