//
//  SweepHistory.h
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#ifndef SweepHistory_h
#define SweepHistory_h

#import <Foundation/Foundation.h>

// 他クラスのheaderファイルを#importすると、クラスが使用可能になる
#import "Mine.h"

/// 地雷撤去の履歴
@interface SweepHistory : NSObject

/// 地雷撤去前の状態
@property (nonatomic, copy) NSArray *mineField;
/// 撤去する地雷
@property (nonatomic) Mine *recentlyCheckedMine;
/// 試行回数
@property (nonatomic) NSInteger numberOfTrials;

/// コンビニエンスコンストラクタ
+ (SweepHistory *)sweepHistoryClassWithMineFields:(NSArray *)minefields
                              recentlyCheckedMine:(Mine *)recentlyCheckedMine
                                   numberOfTrials:(NSInteger)numberOfTrials;

@end

#endif /* SweepHistory_h */
