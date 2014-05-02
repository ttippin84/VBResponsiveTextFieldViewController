//
//  VBResponsiveTextFieldViewController.m
//  VBResponsiveTextField
//
//  Created by Tom Tippin on 2014-03-19.
//  Copyright (c) 2014 Vega Beach Softworks. All rights reserved.
//

#import "VBResponsiveTextFieldViewController.h"

@interface VBResponsiveTextFieldViewController ()

@end

@implementation VBResponsiveTextFieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Observe notifications for when keyboard will show and hide
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
                                               
    // Set a method for UITextField didEndOnExit event to dismiss keyboard
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            [textField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardIsShowing = YES;
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self arrangeViewOffsetFromKeyboard];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardIsShowing = NO;
    [self returnViewToInitialFrame];
}

- (void)arrangeViewOffsetFromKeyboard
{
    // Get a reference to the app's window through the app delegate
    
    UIApplication *theApp = [UIApplication sharedApplication];
    UIView *windowView = (UIView *)theApp.delegate.window;
    
    // Convert the lower point of the active UITextField to the window's coordinate system, and calculate the adjustments of the top level view to the desired position
    
    CGPoint textFieldLowerPoint = CGPointMake(self.activeTextField.frame.origin.x, self.activeTextField.frame.origin.y + self.activeTextField.frame.size.height);
    CGPoint convertedTextFieldLowerPoint = [self.view convertPoint:textFieldLowerPoint toView:windowView];
    
    CGPoint targetTextFieldLowerPoint = CGPointMake(self.activeTextField.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset);
    
    CGFloat targetPointOffset = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y;
    CGPoint adjustedViewFrameCenter = CGPointMake(self.view.center.x,
                                                  self.view.center.y + targetPointOffset);

    [UIView animateWithDuration:0.2 animations:^{
        self.view.center = adjustedViewFrameCenter;
    }];
}

- (void)returnViewToInitialFrame
{
    CGRect initialViewRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    if (!CGRectEqualToRect(initialViewRect, self.view.frame)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = initialViewRect;
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Any touch outside of a UITextField being edited should dismiss the keyboard
    
    if (self.activeTextField) {
        [self.activeTextField resignFirstResponder];
        self.activeTextField = nil;
    }
}

- (IBAction)textFieldDidReturn:(id)sender
{
    [sender resignFirstResponder];
    self.activeTextField = nil;
}

#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // This method is called right before the keyboardWillShow notification is fired. Use it to set the activeTextField variable, which can then be used to calculate the required distance between the top of the keyboard and the bottom of the text field being edited.
    
    self.activeTextField = textField;
    
    if (self.keyboardIsShowing)
        [self arrangeViewOffsetFromKeyboard];
}

@end
