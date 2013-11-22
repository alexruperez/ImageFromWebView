//
//  ViewController.h
//  ImageFromWebView
//
//  Created by Alejandro Rupérez on 22/11/13.
//  Copyright (c) 2012 --. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
