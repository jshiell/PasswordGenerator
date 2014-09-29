//
//  PGGenerator.h
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGGenerator <NSObject>

- (NSString*)generate;
- (BOOL)isFormatted;

@end
