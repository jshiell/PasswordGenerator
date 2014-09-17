//
//  PGPasswordFormatter.h
//  PasswordGenerator
//
//  Created by James Shiell on 17/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGPasswordFormatter : NSObject

@property (nonatomic, strong) UIColor* numberColour;
@property (nonatomic, strong) UIColor* punctuationColour;
@property (nonatomic) NSInteger lineWidthInGroups;
@property (nonatomic) BOOL useLineBreaks;

-(id) initWithLineBreaks:(BOOL)useLineBreaks;

-(NSAttributedString *) format:(NSString *)password;

@end
