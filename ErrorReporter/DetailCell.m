//
//  DetailCell.m
//  ErrorReporter
//
//  Created by Jocer on 2017/3/21.
//  Copyright © 2017年 Jocer. All rights reserved.
//

#import "DetailCell.h"

@interface DetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *deviceModel;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *deviceID;
@property (weak, nonatomic) IBOutlet UILabel *platform;
@property (weak, nonatomic) IBOutlet UILabel *createdTime;
@property (strong, nonatomic) NSDictionary *dic;
@end

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSDictionary *)dic {
    _dic = dic;
    self.deviceID.text = [@"DeviceID:" stringByAppendingString:_dic[@"deviceid"]];
    self.deviceModel.text = [NSString stringWithFormat:@"机型:%@",_dic[@"model"]];
    self.version.text = [NSString stringWithFormat:@"版本:%@",_dic[@"clientversion"]];
    self.platform.text = _dic[@"platform"];
    self.createdTime.text = _dic[@"created_time"];
}

@end
