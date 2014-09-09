//
//  PGMainViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGMainViewController.h"
#import "PGPasswordTableViewController.h"
#import "PGGenerator.h"
#import "PGAlphaNumericGenerator.h"

@interface PGMainViewController ()

@property (nonatomic) int passwordLength;
@property (nonatomic) BOOL useNumbers;
@property (nonatomic) BOOL useLowercaseLetters;
@property (nonatomic) BOOL useUppercaseLetters;
@property (nonatomic) BOOL usePunctuation;
@property (nonatomic) BOOL removeAmbiguousCharacters;
@property (nonatomic) BOOL allowRepitition;

@property (nonatomic, weak) UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *generateButton;

@end

static const int SECTION_LENGTH = 0;

static const int SECTION_INCLUDE = 1;
static const int ROW_LOWERCASE = 0;
static const int ROW_UPPERCASE = 1;
static const int ROW_NUMBERS = 2;
static const int ROW_PUNCTUATION = 3;

static const int SECTION_MODIFIERS = 2;
static const int ROW_AMBIGUOUS = 0;
static const int ROW_REPITITION = 1;

static const int MINIMUM_PASSWORD_LENGTH = 5;
static const int MAXIMUM_PASSWORD_LENGTH = 28;
static const int DEFAULT_PASSWORD_LENGTH = 16;

@implementation PGMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passwordLength = DEFAULT_PASSWORD_LENGTH;
    self.useNumbers = YES;
    self.useLowercaseLetters = YES;
    self.useUppercaseLetters = YES;
    self.usePunctuation = YES;
    self.removeAmbiguousCharacters = NO;
    self.allowRepitition = YES;
}

- (id <PGGenerator>)createGenerator {
    PGAlphaNumericGenerator *generator = [[PGAlphaNumericGenerator alloc] init];
    [generator setLength:self.passwordLength];
    [generator setUseLowercaseLetters:self.useLowercaseLetters];
    [generator setUseUppercaseLetters:self.useUppercaseLetters];
    [generator setUseNumbers:self.useNumbers];
    [generator setUsePunctuation:self.usePunctuation];
    [generator setRemoveAmbiguousCharacters:self.removeAmbiguousCharacters];
    [generator setAllowRepitition:self.allowRepitition];
    return generator;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GeneratePasswords"]) {
        PGPasswordTableViewController* passwordTableViewController = [segue destinationViewController];
        passwordTableViewController.generator = [self createGenerator];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_LENGTH:
            return 1;
        case SECTION_INCLUDE:
            return 4;
        case SECTION_MODIFIERS:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_LENGTH:
            return @"Length";
        case SECTION_INCLUDE:
            return @"Include";
        default:
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case SECTION_INCLUDE:
            return @"Symbols includes characters such as $, % and @";
        default:
            return nil;
    }
}

- (UITableViewCell *)getCellFor:(UITableView *)tableView andReuseIdentifier:(NSString *) reuseIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_LENGTH:
            return [self createPasswordLengthCell:tableView];
            
        case SECTION_INCLUDE:
            return [self createIncludeCells:tableView forRow:indexPath.row];
            
        case SECTION_MODIFIERS:
            return [self createModifierCells:tableView forRow:indexPath.row];
            
        default:
            return nil;
    }
}

- (UITableViewCell *)createPasswordLengthCell:(UITableView *)tableView {
    UITableViewCell *cell = [self getCellFor:tableView andReuseIdentifier:@"SLIDER"];
    
    UISlider *slider = (UISlider *) [cell.contentView viewWithTag:10];
    [slider setMinimumValue:MINIMUM_PASSWORD_LENGTH];
    [slider setMaximumValue:MAXIMUM_PASSWORD_LENGTH];
    [slider setValue:self.passwordLength];
    [slider addTarget:self action:@selector(passwordLengthChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.lengthLabel = (UILabel *) [cell.contentView viewWithTag:20];
    [self.lengthLabel setText:[NSString stringWithFormat:@"%d", self.passwordLength]];
    
    return cell;
}

- (UITableViewCell *)createIncludeCells:(UITableView *)tableView forRow:(int)row {
    switch (row) {
        case ROW_LOWERCASE:
            return [self createSwitchCell:tableView withLabel:@"Lowercase Letters" andSelector:@selector(useUppercaseLettersToggled:) andInitialValue:self.useLowercaseLetters];
            
        case ROW_UPPERCASE:
            return [self createSwitchCell:tableView withLabel:@"Uppercase Letters" andSelector:@selector(useLowercaseLettersToggled:) andInitialValue:self.useUppercaseLetters];
            
        case ROW_NUMBERS:
            return [self createSwitchCell:tableView withLabel:@"Numbers" andSelector:@selector(useNumbersToggled:) andInitialValue:self.useNumbers];
            
        case ROW_PUNCTUATION:
            return [self createSwitchCell:tableView withLabel:@"Symbols" andSelector:@selector(usePunctuationToggled:) andInitialValue:self.usePunctuation];
    }
    
    return nil;
}

- (UITableViewCell *)createModifierCells:(UITableView *)tableView forRow:(int)row {
    switch (row) {
        case ROW_AMBIGUOUS:
            return [self createSwitchCell:tableView withLabel:@"Remove Ambiguous Characters" andSelector:@selector(removeAmbiguousCharactersToggled:) andInitialValue:self.removeAmbiguousCharacters];
            
        case ROW_REPITITION:
            return [self createSwitchCell:tableView withLabel:@"Allow Repitition" andSelector:@selector(allowRepititionToggled:) andInitialValue:self.allowRepitition];
    }
    
    return nil;
}

- (UITableViewCell *)createSwitchCell:(UITableView *)tableView withLabel:(NSString *)labelText andSelector:(SEL)selector andInitialValue:(BOOL)initialValue {
    UITableViewCell *cell = [self getCellFor:tableView andReuseIdentifier:@"SWITCH"];
    
    UILabel *label = (UILabel *) [cell.contentView viewWithTag:10];
    [label setText:labelText];
    
    UISwitch *switcher = (UISwitch *) [cell.contentView viewWithTag:20];
    [switcher setOn:initialValue];
    [switcher addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void)ensureGenerationIsPossible {
    [self.generateButton setEnabled:self.useUppercaseLetters || self.useLowercaseLetters || self.useNumbers || self.usePunctuation];
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
    self.usePunctuation = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)removeAmbiguousCharactersToggled:(UISwitch *)sender {
    self.removeAmbiguousCharacters = sender.on;
    [self ensureGenerationIsPossible];
}

- (IBAction)allowRepititionToggled:(UISwitch *)sender {
    self.usePunctuation = sender.on;
    [self ensureGenerationIsPossible];
}

@end
