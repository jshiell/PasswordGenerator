//
//  PGPasswordDetailViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 17/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGPasswordDetailViewController.h"
#import "PGPasswordFormatter.h"

@interface PGPasswordDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation PGPasswordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPressed)];
    [self.passwordLabel addGestureRecognizer:tapGesture];
    
    PGPasswordFormatter *passwordFormatter = [[PGPasswordFormatter alloc] initWithLineBreaks:YES];
    NSMutableAttributedString *formattedPassword = [[NSMutableAttributedString alloc] initWithAttributedString:[passwordFormatter format:self.password]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 1;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:32],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [formattedPassword addAttributes:attributes range:NSMakeRange(0, [formattedPassword length])];
     
    [self.passwordLabel setAttributedText:formattedPassword];
    [self.passwordLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)labelPressed {
    [UIPasteboard generalPasteboard].string = self.password;
    
    // TODO notify user of copy
}

- (IBAction)sharedPressed:(id)sender {
    NSArray *activityItems = @[self.password];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

@end
