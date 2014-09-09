//
//  PGAlphaNumericGenerator.h
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PGGenerator.h"

@interface PGAlphaNumericGenerator : NSObject <PGGenerator>

@property (nonatomic) int length;
@property (nonatomic) BOOL useNumbers;
@property (nonatomic) BOOL useLowercaseLetters;
@property (nonatomic) BOOL useUppercaseLetters;
@property (nonatomic) BOOL usePunctuation;
@property (nonatomic) BOOL removeAmbiguousCharacters;
@property (nonatomic) BOOL allowRepitition;

- (NSString*)generate;

@end
