//
//  PGGeneratorTableViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 15/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGGeneratorTableViewController.h"
#import "PGAlphaNumericGenerator.h"

@interface PGGeneratorTableViewController ()

@property (nonatomic, readwrite) BOOL valid;
@property (nonatomic) int passwordLength;
@property (nonatomic) BOOL useNumbers;
@property (nonatomic) BOOL useLowercaseLetters;
@property (nonatomic) BOOL useUppercaseLetters;
@property (nonatomic) BOOL useSymbols;
@property (nonatomic) BOOL removeAmbiguousCharacters;
@property (nonatomic) BOOL allowRepitition;

@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UISwitch *lowercaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *uppercaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *numbersSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *symbolsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *removeAmbiguousSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *allowRepititionSwitch;

@end

static const int MINIMUM_PASSWORD_LENGTH = 5;
static const int MAXIMUM_PASSWORD_LENGTH = 64;
static const int DEFAULT_PASSWORD_LENGTH = 20;

@implementation PGGeneratorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordLength = DEFAULT_PASSWORD_LENGTH;
    self.useNumbers = YES;
    self.useLowercaseLetters = YES;
    self.useUppercaseLetters = YES;
    self.useSymbols = YES;
    self.removeAmbiguousCharacters = NO;
    self.allowRepitition = YES;
    
    _valid = YES;
    
    [self.lengthSlider setMinimumValue:MINIMUM_PASSWORD_LENGTH];
    [self.lengthSlider setMaximumValue:MAXIMUM_PASSWORD_LENGTH];
    [self.lengthSlider setValue:self.passwordLength];
    
    [self.lengthLabel setText:[NSString stringWithFormat:@"%d", self.passwordLength]];
    
    [self.lowercaseSwitch setOn:self.useLowercaseLetters];
    [self.uppercaseSwitch setOn:self.useUppercaseLetters];
    [self.numbersSwitch setOn:self.useNumbers];
    [self.symbolsSwitch setOn:self.useSymbols];
    [self.removeAmbiguousSwitch setOn:self.removeAmbiguousCharacters];
    [self.allowRepititionSwitch setOn:self.allowRepitition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id <PGGenerator>)createGenerator {
    PGAlphaNumericGenerator *generator = [[PGAlphaNumericGenerator alloc] init];
    [generator setLength:self.passwordLength];
    [generator setUseLowercaseLetters:self.useLowercaseLetters];
    [generator setUseUppercaseLetters:self.useUppercaseLetters];
    [generator setUseNumbers:self.useNumbers];
    [generator setUsePunctuation:self.useSymbols];
    [generator setRemoveAmbiguousCharacters:self.removeAmbiguousCharacters];
    [generator setAllowRepitition:self.allowRepitition];
    return generator;
}

- (void)ensureGenerationIsPossible {
    self.valid = self.useUppercaseLetters || self.useLowercaseLetters || self.useNumbers || self.useSymbols;
}

- (IBAction)passwordLengthChanged:(UISlider *)sender {
    self.passwordLength = sender.value;
    [self.lengthLabel setText:[NSString stringWithFormat:@"%d", self.passwordLength]];
}

- (IBAction)useNumbersToggled:(UISwitch *)sender {
    self.useNumbers = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)useLowercaseLettersToggled:(UISwitch *)sender {
    self.useLowercaseLetters = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)useUppercaseLettersToggled:(UISwitch *)sender {
    self.useUppercaseLetters = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)usePunctuationToggled:(UISwitch *)sender {
    self.useSymbols = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)removeAmbiguousCharactersToggled:(UISwitch *)sender {
    self.removeAmbiguousCharacters = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)allowRepititionToggled:(UISwitch *)sender {
    self.allowRepitition = sender.on;
    [self ensureGenerationIsPossible];
}

@end
