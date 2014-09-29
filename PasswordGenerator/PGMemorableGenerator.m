//
//  PGMemorableGenerator.m
//  PasswordGenerator
//
//  Created by James Shiell on 29/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//
//  Generation method (Diceware) is Copyright (c) 1995-2014 A G Reinhold
//  and is used under the Creative Commons CC-BY 3.0 license
//  https://creativecommons.org/licenses/by/3.0/

#import "PGMemorableGenerator.h"
#import "PGRandom.h"

@interface PGMemorableGenerator ()

@property (nonatomic, strong) PGRandom *random;
@property (nonatomic, strong) NSDictionary *wordList;

@end

@implementation PGMemorableGenerator

- (id)init {
    if ( self = [super init] ) {
        self.random = [[PGRandom alloc] init];
        self.length = 5;
        
        self.wordList = [self loadWordList:@"diceware.wordlist"];
    }
    return self;
}

- (NSDictionary *)loadWordList:(NSString *)listName {
    NSMutableDictionary *loadedWordList = [[NSMutableDictionary alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:listName ofType:@"txt"];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* fileLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* line in fileLines) {
        NSArray* idAndWord = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([idAndWord count] >= 2) {
            [loadedWordList setValue:[idAndWord objectAtIndex:1] forKey:[idAndWord objectAtIndex:0]];
        }
    }
    
    return [loadedWordList copy];
}

- (NSString *)generate {
    NSMutableString *generated = [[NSMutableString alloc] init];
    
    for (int i = 0; i < self.length; ++i) {
        if (i > 0) {
            [generated appendString:@" "];
        }
        [generated appendString:[self.wordList objectForKey:[self generateKey]]];
    }
    
    return [generated copy];
}

- (BOOL)isFormatted {
    return YES;
}

- (NSString *)generateKey {
    NSMutableString *key = [[NSMutableString alloc] init];
    
    for (int i = 0; i < 5; ++i) {
        [key appendFormat:@"%d", [self.random numberUnder:6] + 1];
    }
    
    return [key copy];
}

@end
