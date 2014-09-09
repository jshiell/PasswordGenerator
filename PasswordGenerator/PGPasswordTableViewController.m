//
//  PGPasswordTableViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGPasswordTableViewController.h"

@interface PGPasswordTableViewController ()

@property (nonatomic, strong) NSMutableArray* generatedPasswords;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) UIColor* numberColour;
@property (nonatomic, strong) UIColor* punctuationColour;

@property (strong, nonatomic) IBOutlet UITableView *passwordTableView;

@end

@implementation PGPasswordTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberColour = [UIColor colorWithRed:0.14 green:0.47 blue:1 alpha:1];
    self.punctuationColour = [UIColor colorWithRed:0.79 green:0.28 blue:0.08 alpha:1];
    
    self.generatedPasswords = [[NSMutableArray alloc] init];
    [self generateNumberOfPasswords: [self numberOfPasswordsToShow]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.passwordTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refreshTable {
    [self generateNumberOfPasswords: [self numberOfPasswordsToShow]];
    
    [self.refreshControl endRefreshing];
    [self.passwordTableView reloadData];
}

- (int)numberOfPasswordsToShow {
    return 10;
}

- (void)generateNumberOfPasswords:(int)count {
    [self.generatedPasswords removeAllObjects];
    for (int i = 0; i < count; ++i) {
        [self.generatedPasswords addObject:[self.generator generate]];
    }
}

- (NSAttributedString *)formatPassword:(NSString *)password {
    NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *alpha = [NSCharacterSet letterCharacterSet];
    
    NSMutableAttributedString *attrPassword = [[NSMutableAttributedString alloc] initWithString: password];
    for (int i = 0; i < [password length]; ++i) {
        unichar currentChar = [password characterAtIndex:i];
        if ([numbers characterIsMember:currentChar]) {
            [attrPassword addAttribute:NSForegroundColorAttributeName value:self.numberColour range:NSMakeRange(i, 1)];
        } else if (![alpha characterIsMember:currentChar]) {
            [attrPassword addAttribute:NSForegroundColorAttributeName value:self.punctuationColour range:NSMakeRange(i, 1)];
        }
    }
    
    return attrPassword;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.generatedPasswords count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"PASSWORD";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    NSString* generatedPassword = [self.generatedPasswords objectAtIndex:indexPath.row];
    
    [cell.textLabel setAttributedText:[self formatPassword:generatedPassword]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Courier" size: [UIFont labelFontSize]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIPasteboard generalPasteboard].string = [self.generatedPasswords objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
