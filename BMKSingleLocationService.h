//
//  BMKSingleLocationService.h
//  Demo
//
//  Created by 付凯 on 2017/7/5.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^SingleLoctionCompletionBlock)(CLLocation *location, NSError *error);

@interface BMKSingleLocationService : NSObject

+ (void)startLocationWithCompletionBlock:(SingleLoctionCompletionBlock)completion;

@end
