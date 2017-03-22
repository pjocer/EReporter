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
@end

@implementation OptionCell

- (void)setData:(NSDictionary *)dic {
    _data = dic;
    self.left.text = [_data objectForKey:@"code"]?:@"";
    self.right.text = [_data objectForKey:@"counts"]?:@"";
    self.right.text = [NSString stringWithFormat:@"%@",self.right.text];
    NSInteger level = [[_data objectForKey:@"level"]?:@"0" integerValue];
    self.levelLabel.hidden = level==0;
    if (level==1) {
        _levelLabel.backgroundColor = [UIColor greenColor];
    }
    if (level==2) {
        _levelLabel.backgroundColor = [UIColor yellowColor];
    }
    if (level==3) {
        _levelLabel.backgroundColor = [UIColor redColor];
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
