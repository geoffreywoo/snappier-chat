//
//  OtoroSentTableViewCell.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 9/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kOtoroSentTableViewCellIdentifier;

@interface OtoroSentTableViewCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
//@property(nonatomic, strong) IBOutlet UIImageView *statusView;
@property(nonatomic, strong) IBOutlet UILabel *timerLabel;


@end
