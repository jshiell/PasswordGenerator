//
//  PGMainViewController.m
//  PasswordGenerator
//
//  Created by James Shiell on 09/09/2014.
//  Copyright (c) 2014 Simia Infinitus. All rights reserved.
//

#import "PGMainViewController.h"
#import "PGPasswordDetailViewController.h"
#import "PGGenerator.h"
#import "PGGeneratorFactory.h"

@interface PGMainViewController ()

@property (strong, nonatomic) UIViewController <PGGeneratorFactory> *memorableGeneratorController;
@property (strong, nonatomic) UIViewController <PGGeneratorFactory> *alphaNumericGeneratorController;
@property (weak, nonatomic) UIViewController <PGGeneratorFactory> *generatorController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *generateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *passwordGeneratorControl;
@property (weak, nonatomic) IBOutlet UIView *generatorContainer;

@end

@implementation PGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alphaNumericGeneratorController = self.childViewControllers.lastObject;
    self.memorableGeneratorController = [self.storyboard instantiateViewControllerWithIdentifier:@"MemorableGenerator"];
}

- (IBAction)passwordGeneratorChanged:(id)sender {
    switch (self.passwordGeneratorControl.selectedSegmentIndex) {
        case 0:
            [self showGeneratorController:self.alphaNumericGeneratorController];
            break;
            
        case 1:
            [self showGeneratorController:self.memorableGeneratorController];
            break;
            
        default:
            break;
    }
}

- (void)showGeneratorController:(UIViewController <PGGeneratorFactory> *)newController {
    if (self.generatorController != newController) {
        [self.generateButton setEnabled:NO];
        
        [self addChildViewController:newController];
        newController.view.frame = self.generatorContainer.bounds;
        [self.generatorController removeObserver:self forKeyPath: NSStringFromSelector(@selector(valid))];
        [self.generatorController willMoveToParentViewController:nil];
        [self transitionFromViewController:self.generatorController
                          toViewController:newController
                                  duration:.5
                                   options:UIViewAnimationOptionCurveEaseInOut
                                animations:nil
                                completion:^(BOOL finished) {
                                    [self.generatorController removeFromParentViewController];
                                    [newController didMoveToParentViewController:self];
                                    
                                    self.generatorController = newController;
                                    [self.generatorController addObserver:self forKeyPath:NSStringFromSelector(@selector(valid)) options:NSKeyValueObservingOptionNew context:NULL];
                                    [self.generateButton setEnabled:newController.valid];
                                }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GeneratorTableEmbed"]) {
        if (self.generatorController) {
            [self.generatorController removeObserver:self forKeyPath: NSStringFromSelector(@selector(valid))];
            self.generatorController = nil;
        }
        
        self.generatorController = (UIViewController <PGGeneratorFactory>*) [segue destinationViewController];
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
