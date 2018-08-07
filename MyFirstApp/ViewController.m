//
//  ViewController.m
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#import "ViewController.h"
#import "Solve.h"
#import "Problem.h"

@interface ViewController ()

/*!
 @method showIndicator
 @abstract インジケーターを画面中央に表示
 */
-(void)showIndicator;

/*!
 @method hideIndicator
 @abstract インジケーターを非表示にする
 */
-(void)hideIndicator;

@end

@implementation ViewController

/*!
 @method BtnPush:sender
 @abstract ボタンクリックイベント
 @discussion パズルを解き始めます。
 */
-(IBAction)BtnPush:(id)sender {
    
    self.button.enabled = NO;
    
    NSLog(@"***** MineSweeper Start. *****");
    
    // インジケーター生成
    [self showIndicator];

    // 非同期処理-開始
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        Solve *solve = [[Solve alloc] init];
        NSArray *mines = [solve exec:[Problem MFAMineField]];
        
        // MBA Corei5で大体70sec
        // TODO: メモリ管理が不明のため、メモリリークがひどい
        
        // 非同期処理-終わり
        dispatch_async(dispatch_get_main_queue(), ^{
        
            // くるくる解除
            [self hideIndicator];
            
            for (SweepHistory *history in mines) {
                Mine *mine = history.recentlyCheckedMine;
                
                NSLog(@"地雷マス X座標:%ld Y座標:%ld", mine.xCoordinate + 1, mine.yCoordinate + 1);
            }
            
            NSLog(@"");
            NSLog(@"答え: pregnant woman.");
            
            NSLog(@"***** MineSweeper Complete. *****");
            [self.button setTitle:@"Finish." forState:UIControlStateNormal];
            self.label1.text = @"お待たせしました！";
            self.label2.text = @"結果がコンソールに出てます！";
        });
    });
}

/*!
 @method showIndicator
 @abstract インジケーターを画面中央に表示
 @discussion 終了時はhideindicatorをコールすること
 */
- (void)showIndicator {

    self.loadingView = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    self.view.backgroundColor = [UIColor grayColor];
    self.loadingView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:self.loadingView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.color = [UIColor blackColor];
    self.indicator.center = self.view.center;
    [self.loadingView addSubview:self.indicator];
    [self.view addSubview:self.loadingView];
    
    [self.indicator startAnimating];
}

/*!
 @method hideIndicator
 @abstract インジケーターを非表示にする
 @discussion 再表示にはshowIndicatorをコールする
 */
- (void)hideIndicator {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.indicator startAnimating];
    [self.indicator removeFromSuperview];
    [self.loadingView removeFromSuperview];
    self.indicator = nil;
    self.loadingView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
