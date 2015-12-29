//
//  PAVerifycell.h
//  VerificationDemo
//
//  Created by DengJinlong on 12/29/15.
//  Copyright © 2015 dengjinlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAVerifyCellModel;
@interface PAVerifycell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *verifyButton;
@property (strong, nonatomic) PAVerifyCellModel *model;

- (void)configCellWithCellModel:(PAVerifyCellModel *)model;

@end
