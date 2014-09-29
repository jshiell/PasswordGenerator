//
//  PGMemorableGenerator.h
//  PasswordGenerator
//
//  Created by James Shiell on 29/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGGenerator.h"

@interface PGMemorableGenerator : NSObject <PGGenerator>

@property (nonatomic) int length;

- (NSString*)generate;
- (BOOL)isFormatted;

@end
