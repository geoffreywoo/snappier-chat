//
//  OtoroSentTableViewCell.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 9/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroSentTableViewCell.h"

NSString * const kOtoroSentTableViewCellIdentifier = @"OtoroSentTableViewCell";


@implementation OtoroSentTableViewCell

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
