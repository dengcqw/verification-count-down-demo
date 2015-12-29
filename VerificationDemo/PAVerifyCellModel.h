//
//  PAVerifyCellModel.h
//  VerificationDemo
//
//  Created by DengJinlong on 12/29/15.
//  Copyright © 2015 dengjinlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACCommand.h"
#import "RACSignal.h"

@interface PAVerifyCellModel : NSObject
@property (copy, nonatomic) NSString *inputText;
@property (strong, nonatomic) RACCommand *verifyCommand; // 发送验证码命令
@property (strong, nonatomic) RACSignal *rac_countDown; // 计数器信号
@end
