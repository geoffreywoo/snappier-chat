//
//  ToroViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puffer.h"

@class Puffer;

@interface ToroViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) Puffer *toro;
@property (nonatomic,strong) IBOutlet UILabel *countDown;
@property (nonatomic,strong)IBOutlet UILabel *message;
@property (nonatomic,strong)IBOutlet UILabel *venue;
- (id)initWithToro:(Puffer *)toro;
@property (nonatomic) bool imageSwapped;
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
@end
