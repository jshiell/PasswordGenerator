//
//  PGMainViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGMainViewController.h"
#import "PGPasswordDetailViewController.h"
#import "PGGeneratorTableViewController.h"
#import "PGGenerator.h"

@interface PGMainViewController ()

@property (weak, nonatomic) PGGeneratorTableViewController *generatorController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *generateButton;

@end

@implementation PGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GeneratorTableEmbed"]) {
        if (self.generatorController) {
            [self.generatorController removeObserver:self forKeyPath: NSStringFromSelector(@selector(valid))];
            self.generatorController = nil;
        }
        
        self.generatorController = [segue destinationViewController];
        [self.generatorController addObserver:self forKeyPath:NSStringFromSelector(@selector(valid)) options:NSKeyValueObservingOptionNew context:NULL];
        
    } else if ([[segue identifier] isEqualToString:@"ShowPasswordDetail"]) {
        PGPasswordDetailViewController* passwordDetailViewController = [segue destinationViewController];
        passwordDetailViewController.generator = [self.generatorController createGenerator];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(valid))]) {
        [self.generateButton setEnabled:[change[NSKeyValueChangeNewKey] boolValue]];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
