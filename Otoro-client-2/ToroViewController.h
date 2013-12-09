//
//  ToroViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toro.h"

@class Toro;

@interface ToroViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) Toro *toro;
@property (nonatomic,strong) IBOutlet UILabel *countDown;
@property (nonatomic,strong)IBOutlet UILabel *message;
@property (nonatomic,strong)IBOutlet UILabel *venue;
- (id)initWithToro:(Toro *)toro;

@end
