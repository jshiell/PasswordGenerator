//
//  PGRandom.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGRandom.h"

@implementation PGRandom

- (UInt32)randomNumber {
    UInt32 randomNumber = 0;
    int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(UInt32), (uint8_t*)&randomNumber);
    if (result != 0) {
        randomNumber = arc4random();
    }
    return randomNumber;
}

- (UInt32)numberUnder: (UInt32) boundaryExclusive {
    if (boundaryExclusive <= 0) {
        NSLog(@"Random number requested under %d", boundaryExclusive);
        return 0;
    }
    
    unsigned maxUsable = ((1U << 31) / boundaryExclusive) * boundaryExclusive;
    
    while (1) {
        unsigned num = [self randomNumber];
        if (num < maxUsable) {
            return num % boundaryExclusive;
        }
    }
}

@end
