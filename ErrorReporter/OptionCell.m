//
//  OptionCell.m
//  ErrorReporter
//
//  Created by Jocer on 2017/3/21.
//  Copyright © 2017年 Jocer. All rights reserved.
//

#import "OptionCell.h"

@interface OptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *left;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (nonatomic, strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@end

@implementation OptionCell

- (void)setData:(NSDictionary *)dic {
    _data = dic;
    self.left.text = [NSString stringWithFormat:@"code:%@",[_data objectForKey:@"code"]?:@""];
    self.right.text = [_data objectForKey:@"counts"]?:@"";
    self.right.text = [NSString stringWithFormat:@"%@次",self.right.text];
    NSInteger level = [[_data objectForKey:@"level"]?:@"0" integerValue];
    self.levelLabel.hidden = level==0;
    if (level==1) {
        _levelLabel.text = @"正常";
    }
    if (level==2) {
        _levelLabel.text = @"⚠️";
    }
    if (level==3) {
        _levelLabel.text = @"❌";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
