//
//  PGRandom.h
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGRandom : NSObject

- (UInt32)numberUnder: (UInt32) boundaryExclusive;

@end
