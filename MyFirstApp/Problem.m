//
//  Problem.m
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#import "Problem.h"

/// 横幅
const NSInteger kMineFieldColumnLength = 6;
/// 縦幅
const NSInteger kMineFieldRowLength = 8;

@implementation Problem

/// 問題の地雷源配列を生成するメソッド
+ (NSArray *)MFAMineField {
    static NSArray *mineField;
    // コレクション型の静的定数が作れない言語仕様のため、
    // GCD dispatch_onceを使って初期化する
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // ArrayのRank1が横軸, Rank2が縦軸のため、
        // 問題の画面とはXYが逆に見える
        mineField = [@[
                      [@[ @1, @1, @1, @2, @2, @2, @2, @2 ] mutableCopy],
                      [@[ @2, @2, @2, @2, @2, @2, @2, @2 ] mutableCopy],
                      [@[ @2, @2, @1, @2, @2, @2, @2, @2 ] mutableCopy],
                      [@[ @1, @2, @2, @2, @1, @1, @1, @1 ] mutableCopy],
                      [@[ @1, @2, @3, @3, @3, @2, @3, @2 ] mutableCopy],
                      [@[ @1, @2, @3, @2, @2, @1, @2, @1 ] mutableCopy],
                    ] mutableCopy];
    });
    return mineField;
}

@end
