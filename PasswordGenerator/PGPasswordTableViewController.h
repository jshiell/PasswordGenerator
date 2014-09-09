//
//  PGPasswordTableViewController.h
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGenerator.h"

@interface PGPasswordTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id <PGGenerator> generator;

@end
