//
//  PGGeneratorFactory.h
//  PasswordGenerator
//
//  Created by James Shiell on 29/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGGenerator.h"

@protocol PGGeneratorFactory <NSObject>

@property (nonatomic, readonly) BOOL valid;

- (id <PGGenerator>)createGenerator;

@end
