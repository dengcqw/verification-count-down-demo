//
//  PAVerifycell.m
//  VerificationDemo
//
//  Created by DengJinlong on 12/29/15.
//  Copyright © 2015 dengjinlong. All rights reserved.
//

#import "PAVerifycell.h"
#import "PAVerifyCellModel.h"
#import "RACSignal.h"
#import "NSObject+RACPropertySubscribing.h"
#import "EXTScope.h"
#import "UITextField+RACSignalSupport.h"
#import "RACSubscriptingAssignmentTrampoline.h"
#import "NSObject+RACLifting.h"
#import "UIView+MGEasyFrame.h"
#import "UITableViewCell+RACSignalSupport.h"
#import "RACSignal+Operations.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation PAVerifycell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.verifyButton];
    }
    
    return self;
}

- (void)configCellWithCellModel:(PAVerifyCellModel *)model {
    self.model = model;
    
    self.textField.text = self.model.inputText;
    
    @weakify(self);
    [self.textField.rac_textSignal subscribeNext:^(NSString *inputText) {
        @strongify(self);
        self.model.inputText = inputText;
    }];
    
    [[self.textField.rac_textSignal map:^id(NSString *value) {
        @strongify(self);
        return @(value.length>0 && self.model.rac_countDown == nil); 
    }] subscribeNext:^(NSNumber *enabled) {
        @strongify(self);
        self.verifyButton.enabled = enabled.boolValue;
    }];
    
    [self rac_liftSelector:@selector(countDownSignalChanged:) withSignals:[RACObserve(self, model.rac_countDown) ignore:nil], nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame =  CGRectMake(15, 0, self.contentView.width - 15 - 15 - self.verifyButton.width, self.contentView.height);
    self.verifyButton.left = self.textField.right;
    self.verifyButton.top = (self.contentView.height - self.verifyButton.height)/2;
} 

- (UITextField *)textField {
    if (nil == _textField) {
        UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
        textField.font = [UIFont systemFontOfSize:18];
        textField.textColor = UIColorFromRGB(0x1d1d1d);
        textField.keyboardAppearance = UIKeyboardAppearanceDefault;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"请输入验证码";
        self.textField = textField;
    }
    return _textField;
}

- (UIButton *)verifyButton {
    if (nil == _verifyButton) {
        UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        aButton.titleLabel.font = [UIFont systemFontOfSize:14];
        aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [aButton setTitleColor:UIColorFromRGB(0x818181) forState:UIControlStateDisabled];
        [aButton setTitleColor:UIColorFromRGB(0xffa566) forState:UIControlStateNormal];
        aButton.backgroundColor = [UIColor clearColor];
        aButton.layer.borderColor = UIColorFromRGB(0x818181).CGColor;
        aButton.layer.cornerRadius = 3;
        aButton.layer.borderWidth = 1.0;
        [aButton addTarget:self action:@selector(verifyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [RACObserve(aButton, enabled) subscribeNext:^(NSNumber *value) {
            BOOL enable = value.boolValue;
            if (enable) {
                aButton.layer.borderColor = UIColorFromRGB(0xffa566).CGColor;
            } else {
                aButton.layer.borderColor = UIColorFromRGB(0x818181).CGColor;
            }
        }];
        self.verifyButton = aButton;
    }
    return _verifyButton;
}

- (void)verifyButtonAction:(id)sender {
    [self.model.verifyCommand execute:self.model];
}

- (void)countDownSignalChanged:(RACSignal *)countDownSignal {
    self.verifyButton.enabled = NO; 
    @weakify(self);
    [countDownSignal subscribeNext:^(NSNumber *count) {
        NSString *text = [NSString stringWithFormat:@"%@s后重发", count];
        if (count.integerValue == 0) {
            text = @"获取验证码";
        }
        @strongify(self);
        [self.verifyButton setTitle:text forState:UIControlStateDisabled];
    } completed:^{
        @strongify(self);
        self.model.rac_countDown = nil;
        self.verifyButton.enabled = YES; 
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
