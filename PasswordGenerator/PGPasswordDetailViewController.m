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

@property (nonatomic, strong) NSString *password;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation PGPasswordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generatePassword:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sharedPressed:(id)sender {
    NSArray *activityItems = @[self.password];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

- (IBAction)generatePassword:(id)sender {
    self.password = [self.generator generate];
    [self displayPassword:self.password];
}

-(void)viewDidLayoutSubviews {
}

- (BOOL)isLandscape {
    if (self.view.frame.size.width == ([[UIScreen mainScreen] bounds].size.width * ([[UIScreen mainScreen] bounds].size.width < [[UIScreen mainScreen] bounds].size.height))
        + ([[UIScreen mainScreen] bounds].size.height * ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height))) {
        return NO;
    }
    return YES;
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation {
    [self displayPassword:self.password];
}

- (void)displayPassword:(NSString *)password {
    PGPasswordFormatter *passwordFormatter = [[PGPasswordFormatter alloc] initWithSpacingAdded:![self.generator hasSignificantWhitespace] andWrapping:YES];
    [passwordFormatter setLineWidthInGroups:(int) self.view.frame.size.width / 100];
    NSMutableAttributedString *formattedPassword = [[NSMutableAttributedString alloc] initWithAttributedString:[passwordFormatter format:password]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 1;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:32],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [formattedPassword addAttributes:attributes range:NSMakeRange(0, [formattedPassword length])];
    
    [self.passwordLabel setAttributedText:formattedPassword];
    [self.passwordLabel sizeToFit];

}

@end
