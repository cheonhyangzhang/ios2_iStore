//
//  myTableCell.m
//  iStore
//
//  Created by cheonhyang on 13-4-26.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "myTableCell.h"

@implementation myTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
