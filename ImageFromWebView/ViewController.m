//
//  ViewController.m
//  ImageFromWebView
//
//  Created by Alejandro Rupérez on 22/11/13.
//  Copyright (c) 2012 --. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImage *image;

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/search?tbm=isch&q=alexruperez"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPressGesture setMinimumPressDuration:0.5f];
    [longPressGesture setDelegate:self];
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {

        CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
        
        if (touchPoint.y <= (self.webView.frame.origin.y + self.webView.frame.size.height))
        {
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                touchPoint.y -= 20.0f;
            }
            
            NSString *imageURLString = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imageURLString];
            NSURL * imageURL = [NSURL URLWithString:urlToSave];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            self.image = imageData ? [UIImage imageWithData:imageData] : nil;
            
            if (self.image)
            {
                [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", nil] showInView:self.view];
            }

        }

    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none';"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex)
    {
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Image saved in your photo album." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"I need access to your gallery." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
}

@end
