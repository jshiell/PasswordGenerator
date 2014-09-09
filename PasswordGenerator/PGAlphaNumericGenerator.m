//
//  PGAlphaNumericGenerator.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGAlphaNumericGenerator.h"
#import "PGRandom.h"

@interface PGAlphaNumericGenerator()

@property (nonatomic, strong) PGRandom *random;

@end

@implementation PGAlphaNumericGenerator

- (id)init {
    if ( self = [super init] ) {
        self.random = [[PGRandom alloc] init];
        self.length = 16;
        self.useLowercaseLetters = YES;
        self.useUppercaseLetters = YES;
        self.useNumbers = YES;
        self.usePunctuation = YES;
        self.removeAmbiguousCharacters = NO;
        self.allowRepitition = YES;
    }
    return self;
}

- (NSString *)generate {
    NSMutableString *generated = [[NSMutableString alloc] init];

    NSArray *symbols = [self availableSymbols];
    NSString *lastSymbol = nil;
    for (int i = 0; i < self.length; ++i) {
        NSString *nextSymbol = [symbols objectAtIndex: [self.random numberUnder:[symbols count]]];
        while (self.removeAmbiguousCharacters
            && lastSymbol != nil
            && [lastSymbol isEqualToString:nextSymbol]) {
            nextSymbol = [symbols objectAtIndex: [self.random numberUnder:[symbols count]]];
        }
        [generated appendString:nextSymbol];
        lastSymbol = nextSymbol;
    }

    return [generated copy];
}

- (NSArray *)availableSymbols {
    NSMutableArray *symbols = [[NSMutableArray alloc] init];
    
    if (self.useNumbers) {
        [symbols addObjectsFromArray:[self numbers]];
    }

    if (self.useLowercaseLetters) {
        [symbols addObjectsFromArray:[self lowercaseLetters]];
    }
    
    if (self.useUppercaseLetters) {
        [symbols addObjectsFromArray:[self uppercaseLetters]];
    }
    
    if (self.usePunctuation) {
        [symbols addObjectsFromArray:[self punctuationSymbols]];
    }
    
    if (self.removeAmbiguousCharacters) {
        [symbols removeObjectsInArray:[self ambiguousCharacters]];
    }
    
    return [symbols copy];
}

- (NSArray *)numbers {
    return @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
}

- (NSArray *)lowercaseLetters {
    return @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m",
             @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
}

- (NSArray *)uppercaseLetters {
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
             @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (NSArray *)punctuationSymbols {
    return @[@"~", @"!", @"#", @"$", @"%", @"^", @"&", @"*", @"(", @")", @"-", @"=", @"+",
             @"[", @"]", @"\\", @"{", @"}", @":", @";", @"\"", @"'", @"<", @">", @"?", @"/"];
}

- (NSArray *)ambiguousCharacters {
    return @[@"i", @"I", @"l", @"1", @"o", @"O", @"0"];
}

@end
