//
//  SearchFriendView.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SearchFriendView.h"

@implementation SearchFriendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SearchFriendView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SearchFriendView" owner:self options:nil];
    [self addSubview:self.view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
