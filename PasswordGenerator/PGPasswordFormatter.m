//
//  PGPasswordFormatter.m
//  PasswordGenerator
//
//  Created by James Shiell on 17/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGPasswordFormatter.h"

@implementation PGPasswordFormatter

-(id) init {
    return [self initWithSpacingAdded:YES andWrapping:NO];
}

-(id) initWithSpacingAdded:(BOOL)addSpacing andWrapping:(BOOL)wrapLines; {
    if (self = [super init]) {
        self.addSpacing = addSpacing;
        self.wrapLines = wrapLines;

        self.numberColour = [UIColor colorWithRed:0.14 green:0.47 blue:1 alpha:1];
        self.punctuationColour = [UIColor colorWithRed:0.79 green:0.28 blue:0.08 alpha:1];
        self.lineWidthInGroups = 3;
    }
    return self;
}

-(NSAttributedString *) format:(NSString *)password {
    return [self highlightElements:[self addSpacingIfRequired:password]];
}

- (NSAttributedString*)highlightElements:(NSString*)password {
    NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *alpha = [NSCharacterSet letterCharacterSet];
    NSMutableAttributedString *attrPassword = [[NSMutableAttributedString alloc] initWithString: password];

    for (int i = 0; i < [password length]; ++i) {
        unichar currentChar = [password characterAtIndex:i];
        if ([numbers characterIsMember:currentChar]) {
            [attrPassword addAttribute:NSForegroundColorAttributeName value:self.numberColour range:NSMakeRange(i, 1)];
        } else if (currentChar != ' ' && ![alpha characterIsMember:currentChar]) {
            [attrPassword addAttribute:NSForegroundColorAttributeName value:self.punctuationColour range:NSMakeRange(i, 1)];
        }
    }
    
    return attrPassword;
}

- (NSString*)addSpacingIfRequired:(NSString*)unprocessedString {
    if (!self.addSpacing) {
        return [[NSMutableString alloc] initWithString:unprocessedString];
    }
    
    NSMutableString *spacedPassword = [[NSMutableString alloc] init];
    int groupSize = [self groupSizeFor:unprocessedString];
    int groups = 0;

    for (int i = 0; i < [unprocessedString length]; ++i) {
        if (i > 0 && i % groupSize == 0) {
            ++groups;
            if (self.wrapLines == YES && groups % self.lineWidthInGroups == 0) {
                [spacedPassword appendString:@"\n"];
            } else {
                [spacedPassword appendString:@" "];
            }
        }
        [spacedPassword appendString: [unprocessedString substringWithRange:NSMakeRange(i, 1)]];
    }

    return spacedPassword;
}

- (int)groupSizeFor:(NSString *)text {
    if ([text length] % 4 == 0) {
        return 4;
    }
    if ([text length] % 3 == 0 || [text length] % 3 > [text length] % 4) {
        return 3;
    }
    return 4;
}

@end

