//
//  ViewController.h
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic) UIView *loadingView;
@property (nonatomic) UIActivityIndicatorView *indicator;

-(IBAction)BtnPush:(id)sender;

@end

