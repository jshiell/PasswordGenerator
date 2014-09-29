//
//  PGMemorableGeneratorTableViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 29/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGMemorableGeneratorTableViewController.h"
#import "PGMemorableGenerator.h"

@interface PGMemorableGeneratorTableViewController ()

@property (nonatomic) int passwordLength;

@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;

@end

static const int MINIMUM_PASSWORD_LENGTH = 1;
static const int MAXIMUM_PASSWORD_LENGTH = 25;
static const int DEFAULT_PASSWORD_LENGTH = 6;

@implementation PGMemorableGeneratorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordLength = DEFAULT_PASSWORD_LENGTH;
    _valid = YES;
    
    [self.lengthSlider setMinimumValue:MINIMUM_PASSWORD_LENGTH];
    [self.lengthSlider setMaximumValue:MAXIMUM_PASSWORD_LENGTH];
    [self.lengthSlider setValue:self.passwordLength];
    
    [self.lengthLabel setText:[NSString stringWithFormat:@"%d", self.passwordLength]];
}

- (id <PGGenerator>)createGenerator {
    PGMemorableGenerator *generator = [[PGMemorableGenerator alloc] init];
    generator.length = self.passwordLength;
    return generator;
}

- (IBAction)passwordLengthChanged:(UISlider *)sender {
    self.passwordLength = sender.value;
    [self.lengthLabel setText:[NSString stringWithFormat:@"%d", self.passwordLength]];
}

@end
