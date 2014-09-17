//
//  PGPasswordTableViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGPasswordTableViewController.h"
#import "PGPasswordDetailViewController.h"
#import "PGPasswordFormatter.h"

@interface PGPasswordTableViewController ()

@property (nonatomic, strong) NSMutableArray* generatedPasswords;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) PGPasswordFormatter* passwordFormatter;

@property (strong, nonatomic) IBOutlet UITableView *passwordTableView;

@end

@implementation PGPasswordTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passwordFormatter = [[PGPasswordFormatter alloc] init];
    
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
    return 10; // TODO this should be based on screen size, ish
}

- (void)generateNumberOfPasswords:(int)count {
    [self.generatedPasswords removeAllObjects];
    for (int i = 0; i < count; ++i) {
        [self.generatedPasswords addObject:[self.generator generate]];
    }
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
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Courier" size: [UIFont labelFontSize]]];
    [cell.textLabel setAttributedText:[self.passwordFormatter format:generatedPassword]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPasswordDetail"]) {
        NSIndexPath *selectionPath = [self.passwordTableView indexPathForSelectedRow];
        PGPasswordDetailViewController *controller = [segue destinationViewController];
        controller.password = [self.generatedPasswords objectAtIndex:selectionPath.row];
    }
}

@end
