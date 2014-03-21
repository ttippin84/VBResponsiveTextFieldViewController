//
//  VBResponsiveTextFieldViewController.h
//  VBResponsiveTextField
//
//  Created by Tom Tippin on 2014-03-19.
//  Copyright (c) 2014 Vega Beach Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBResponsiveTextFieldViewController : UIViewController

// Define an acceptable distance of points between the keyboard and the active UITextField

#define kPreferredTextFieldToKeyboardOffset 20.0

@property (nonatomic) CGRect keyboardFrame;
@property (nonatomic) BOOL keyboardIsShowing;
@property (weak, nonatomic) UITextField *activeTextField;

@end
