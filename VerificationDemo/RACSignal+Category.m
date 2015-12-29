//
//  RACSignal+Category.m
//  VerificationDemo
//
//  Created by DengJinlong on 12/29/15.
//  Copyright © 2015 dengjinlong. All rights reserved.
//

#import "RACSignal+Category.h"
#import "RACScheduler.h"
#import "RACSignal+Operations.h"

@implementation RACSignal (Category)

+ (instancetype)countdownSignal {
    return [[RACSignal return:@60] flattenMap:^RACStream *(NSNumber *startValue) {
        __block NSUInteger count = startValue.unsignedIntegerValue;
        return [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] map:^id(id value) {
            count --;
            return @(count).stringValue;
        }] take:60];
    }];
}

@end
