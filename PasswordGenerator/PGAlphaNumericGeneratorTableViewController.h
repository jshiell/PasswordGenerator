//
//  PGAlphaNumericGeneratorTableViewController.h
//  PasswordGenerator
//
//  Created by James Shiell on 15/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGenerator.h"
#import "PGGeneratorFactory.h"

@interface PGAlphaNumericGeneratorTableViewController : UITableViewController <PGGeneratorFactory>

@property (nonatomic, readonly) BOOL valid;

- (id <PGGenerator>)createGenerator;

@end

