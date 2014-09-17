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
    return [self initWithLineBreaks:NO];
}

-(id) initWithLineBreaks:(BOOL)useLineBreaks {
    if (self = [super init]) {
        self.useLineBreaks = useLineBreaks;

        self.numberColour = [UIColor colorWithRed:0.14 green:0.47 blue:1 alpha:1];
        self.punctuationColour = [UIColor colorWithRed:0.79 green:0.28 blue:0.08 alpha:1];
        self.lineWidthInGroups = 3;
    }
    return self;
}

-(NSAttributedString *) format:(NSString *)password {
    NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *alpha = [NSCharacterSet letterCharacterSet];
    
    NSMutableString *spacedPassword = [[NSMutableString alloc] init];
    int groupSize = [self groupSizeFor:password];
    int groups = 0;
    for (int i = 0; i < [password length]; ++i) {
        if (i > 0 && i % groupSize == 0) {
            ++groups;
            if (self.useLineBreaks == YES && groups % self.lineWidthInGroups == 0) {
                [spacedPassword appendString:@"\n"];                
            } else {
                [spacedPassword appendString:@" "];
            }
        }
        [spacedPassword appendString: [password substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSMutableAttributedString *attrPassword = [[NSMutableAttributedString alloc] initWithString: spacedPassword];
    for (int i = 0; i < [spacedPassword length]; ++i) {
        unichar currentChar = [spacedPassword characterAtIndex:i];
        if ([numbers characterIsMember:currentChar]) {
            [attrPassword addAttribute:NSForegroundColorAttributeName value:self.numberColour range:NSMakeRange(i, 1)];
        } else if (currentChar != ' ' && ![alpha characterIsMember:currentChar]) {
            [attrPassword addAttribute:NSForegroundColorAttributeName value:self.punctuationColour range:NSMakeRange(i, 1)];
        }
    }
    
    return attrPassword;
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

