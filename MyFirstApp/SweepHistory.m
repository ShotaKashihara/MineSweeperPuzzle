//
//  SweepHistory.m
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#import "SweepHistory.h"

@implementation SweepHistory : NSObject

/// コンビニエンスコンストラクタ
+ (SweepHistory *)sweepHistoryClassWithMineFields:(NSArray *)minefields
                              recentlyCheckedMine:(Mine *)recentlyCheckedMine
                                   numberOfTrials:(NSInteger)numberOfTrials {
    SweepHistory* sweepHistory = [[self alloc] init];
    sweepHistory.mineField = minefields;
    sweepHistory.recentlyCheckedMine = recentlyCheckedMine;
    sweepHistory.numberOfTrials = numberOfTrials;
    return sweepHistory;
}

@end
