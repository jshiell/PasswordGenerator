//
//  PGPasswordDetailViewController.h
//  PasswordGenerator
//
//  Created by James Shiell on 17/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGenerator.h"

@interface PGPasswordDetailViewController : UIViewController

@property (nonatomic, strong) id <PGGenerator> generator;

@end
