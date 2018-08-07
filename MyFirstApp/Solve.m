//
//  Solve.m
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#import "Solve.h"

// privateなメンバはクラスエクステンション内でpropertyとして宣言する。
@interface Solve()
@property BOOL privateTest;
@end

// クラスの実装
@implementation Solve

/*!
 @method exec:originMineField
 @abstract MineSweeperパズルを解きます
 @dicussion 与えられた問題が解けるまで try and error
 @param originMineField 問題の地雷源２次元配列
 @result 地雷の座標リスト
 */
- (NSArray *)exec: (NSArray *)originMineField {
    // 解析経過リスト
    NSMutableArray *sweepHistorys = [NSMutableArray array];
    
    // 地雷源配列のdeep copy
    //NSMutableArray *mineField = [[NSMutableArray alloc] initWithArray:originMineField copyItems:YES];
    NSMutableArray *mineField = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:originMineField]];
    
    NSInteger skip = 0;
    
    // 地雷が全て撤去されるまでループ
    while ([self existMine:mineField]) {
        Mine *target = [self nextTarget:mineField skip:skip];
        if (target == nil) {
            // 一手前に戻す
            SweepHistory *history = [sweepHistorys lastObject];
            mineField = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:history.mineField]];
            skip = history.numberOfTrials + 1;
            [sweepHistorys removeLastObject];
            continue;
        }
        NSArray *copyField = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:mineField]];
        [sweepHistorys addObject:[SweepHistory sweepHistoryClassWithMineFields:copyField recentlyCheckedMine:target numberOfTrials:skip]];
        skip = 0;
        mineField = [self sweepMine:mineField mine:target];
    }
    
    // 解析結果を返却
    // MBA Corei5で大体70sec
    // TODO: メモリリークがひどい
    return [sweepHistorys copy];
}

/*!
 @method  existMine:mineField
 @abstract 地雷が残っていないか判定
 @discussion 二次元配列のNSArrayをforで回して、"0"以外があった時点でYESを返却する
 @param mineField 判定する地雷源配列
 @result YES: 地雷あり, NO: 地雷なし
 */
- (BOOL) existMine: (NSArray *)mineField {
    
    for (NSArray *array in mineField) {
        for (NSNumber *value in array) {
            if ([value isEqualToNumber:@0] == NO) {
                return YES;
            }
        }
    }
    return NO;
}

/*!
 @method nextTarget:mineField:skip
 @abstract 次に試す地雷マスの取得
 @discussion 残ったマスから優先度ルールに従い、次のマスを選択する
 @param mineField 判定する地雷源配列
 @param skip 試行回数
 @result 次に試す地雷マス
 */
- (Mine *)nextTarget: (NSArray *)mineField skip:(NSInteger)skip {
    
    // 地雷の可能性があるマスをリストアップ
    NSMutableArray *targets = [NSMutableArray array];
    for (NSInteger x = 0; x < kMineFieldColumnLength; x++) {
        for (NSInteger y = 0; y < kMineFieldRowLength; y++) {
            Mine *mine = [Mine mineClassWithXCoordinate:x yCoordinate:y value:[mineField[x][y] integerValue]];
            // 検証１＆検証２＆検証３
            if (! [self failureCase1:mineField mine:mine]
                && ! [self failureCase2:mineField mine:mine]
                //&& ! [self failureCase3:mineField mine:mine] // メモリリークで返って遅くなるのでコメントアウト
                ){
                // 候補マスをリストに追加
                [targets addObject:mine];
            }
        }
    }
    
    if (targets.count <= skip) {
        return nil;
    }
    
    // (マスの数値:降順, X座標:昇順, Y座標:昇順) でソートして、
    // 試行回数分スキップしたポイントを次のターゲットマスとする。
    NSArray *sortedArray = [[targets sortedArrayUsingSelector:@selector(comparePriority:)] copy];
    
    return sortedArray[skip];
}

/*!
 @method failureCase1:mineField:mine
 @abstract 検証その１
 @discussion 指定マスを含む周囲９マスの中に「0」がいる場合、地雷マスではない
 
 ｜1｜1｜0｜
 ｜1｜x｜1｜ ← このような場合。
 ｜1｜1｜1｜
 
 @param mineField 判定する地雷源配列
 @param mine 指定マス
 @result YES: 「0」がある. NO: 「0」がない
 */
- (BOOL)failureCase1: (NSArray *)mineField mine:(Mine *)mine {
    // 中心マス
    if ([mineField[mine.xCoordinate][mine.yCoordinate] integerValue] == 0) {
        return YES;
    }
    // 上マス
    if (mine.yCoordinate != 0) {
        if ([mineField[mine.xCoordinate][mine.yCoordinate - 1] integerValue] == 0) {
            return YES;
        }
    }
    // 下マス
    if (mine.yCoordinate != kMineFieldRowLength - 1) {
        if ([mineField[mine.xCoordinate][mine.yCoordinate + 1] integerValue] == 0) {
            return YES;
        }
    }
    
    // 左上・左・左下マス
    if (mine.xCoordinate != 0) {
        if (mine.yCoordinate != 0) {
            if ([mineField[mine.xCoordinate - 1][mine.yCoordinate - 1] integerValue] == 0) {
                return YES;
            }
        }
        if ([mineField[mine.xCoordinate - 1][mine.yCoordinate] integerValue] == 0) {
            return YES;
        }
        if (mine.yCoordinate != kMineFieldRowLength - 1) {
            if ([mineField[mine.xCoordinate - 1][mine.yCoordinate + 1] integerValue] == 0) {
                return YES;
            }
        }
    }
    
    // 右上・右・右下マス
    if (mine.xCoordinate != kMineFieldColumnLength - 1) {
        if (mine.yCoordinate != 0) {
            if ([mineField[mine.xCoordinate + 1][mine.yCoordinate - 1] integerValue] == 0) {
                return YES;
            }
        }
        if ([mineField[mine.xCoordinate + 1][mine.yCoordinate] integerValue] == 0) {
            return YES;
        }
        if (mine.yCoordinate != kMineFieldRowLength - 1) {
            if ([mineField[mine.xCoordinate + 1][mine.yCoordinate + 1] integerValue] == 0) {
                return YES;
            }
        }
    }
    return NO;
}

/*!
 @method failureCase2:mineField:mine
 @abstract 検証その２
 @discussion 指定マスに地雷を置いた後、
 
 ｜ ｜1｜ ｜ ← この「１」のように、詰みの状態にならないか検証する。
 ｜1｜1｜1｜
 ｜2｜2｜2｜
 
 @param mineField 判定する地雷源配列
 @param mine 指定マス
 */
- (BOOL)failureCase2: (NSArray *)mineField mine:(Mine *)mine {
    NSMutableArray *mineFields = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:mineField]];
    
    mineFields = [self sweepMine:mineFields mine:mine];
    for (NSInteger y = 0; y < kMineFieldRowLength; y++) {
        for (NSInteger x = 0; x < kMineFieldColumnLength - 2; x++) {
            if ([mineFields[x][y] integerValue] == 0
                && [mineFields[x + 1][y] integerValue] != 0
                && [mineFields[x + 2][y] integerValue] == 0) {
                return YES;
            }
        }
    }
    for (NSInteger x = 0; x < kMineFieldColumnLength; x++) {
        for (NSInteger y = 0; y < kMineFieldRowLength - 2; y++) {
            if ([mineFields[x][y] integerValue] == 0
                && [mineFields[x][y + 1] integerValue] != 0
                && [mineFields[x][y + 2] integerValue] == 0) {
                return YES;
            }
        }
    }
    return NO;
}

/*!
 @method failureCase3:mineField:mine
 @abstract 検証その３
 @discussion 指定マスに地雷を置いた後、
 
 ｜ ｜ ｜1｜ ← この「１」のように、詰みの状態にならないか検証する。
 ｜1｜1｜1｜
 ｜2｜2｜2｜
 
 @param mineField 判定する地雷源配列
 @param mine 指定マス
 */
- (BOOL)failureCase3: (NSArray *)mineField mine:(Mine *)mine {
    NSMutableArray *mineFields = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:mineField]];
    mineFields = [self sweepMine:mineFields mine:mine];
    for (NSInteger x = 0; x < kMineFieldColumnLength; x++) {
        if ([mineFields[x][0] integerValue] != 0
            && [mineFields[x][1] integerValue] == 0) {
            return YES;
        }
        if ([mineFields[x][kMineFieldRowLength - 1] integerValue] != 0
            && [mineFields[x][kMineFieldRowLength - 2] integerValue] == 0) {
            return YES;
        }
    }
    for (NSInteger y = 0; y < kMineFieldRowLength; y++) {
        if ([mineFields[0][y] integerValue] != 0
            && [mineFields[1][y] integerValue] == 0) {
            return YES;
        }
        if ([mineFields[kMineFieldColumnLength - 1][y] integerValue] != 0
            && [mineFields[kMineFieldColumnLength - 2][y] integerValue] == 0) {
            return YES;
        }
    }
    return NO;
}

/*!
 @method sweepMine:mineField:mine
 @abstract 指定マスを含む周囲９マスの数値をマイナス１
 @param mineField 操作する地雷源配列
 @param mine 指定マス
 @result 操作結果
 */
- (NSMutableArray *)sweepMine: (NSMutableArray *)mineField mine:(Mine *)mine {
    // 中心マス
    mineField[mine.xCoordinate][mine.yCoordinate]
     = [NSNumber numberWithInteger:([mineField[mine.xCoordinate][mine.yCoordinate] integerValue] - 1)];
    // 上マス
    if (mine.yCoordinate != 0) {
        mineField[mine.xCoordinate][mine.yCoordinate - 1]
        = [NSNumber numberWithInteger:([mineField[mine.xCoordinate][mine.yCoordinate - 1] integerValue] - 1)];
    }
    // 下マス
    if (mine.yCoordinate != kMineFieldRowLength - 1) {
        mineField[mine.xCoordinate][mine.yCoordinate + 1]
        = [NSNumber numberWithInteger:([mineField[mine.xCoordinate][mine.yCoordinate + 1] integerValue] - 1)];
    }
    
    // 左上・左・左下マス
    if (mine.xCoordinate != 0) {
        if (mine.yCoordinate != 0) {
            mineField[mine.xCoordinate - 1][mine.yCoordinate - 1]
            = [NSNumber numberWithInteger:([mineField[mine.xCoordinate - 1][mine.yCoordinate - 1] integerValue] - 1)];
        }
        mineField[mine.xCoordinate - 1][mine.yCoordinate]
        = [NSNumber numberWithInteger:([mineField[mine.xCoordinate - 1][mine.yCoordinate] integerValue] - 1)];
        if (mine.yCoordinate != kMineFieldRowLength - 1) {
            mineField[mine.xCoordinate - 1][mine.yCoordinate + 1]
            = [NSNumber numberWithInteger:([mineField[mine.xCoordinate - 1][mine.yCoordinate + 1] integerValue] - 1)];
        }
    }
    
    // 右上・右・右下マス
    if (mine.xCoordinate != kMineFieldColumnLength - 1) {
        if (mine.yCoordinate != 0) {
            mineField[mine.xCoordinate + 1][mine.yCoordinate - 1]
            = [NSNumber numberWithInteger:([mineField[mine.xCoordinate + 1][mine.yCoordinate - 1] integerValue] - 1)];
        }
        mineField[mine.xCoordinate + 1][mine.yCoordinate]
        = [NSNumber numberWithInteger:([mineField[mine.xCoordinate + 1][mine.yCoordinate] integerValue] - 1)];
        if (mine.yCoordinate != kMineFieldRowLength - 1) {
            mineField[mine.xCoordinate + 1][mine.yCoordinate + 1]
            = [NSNumber numberWithInteger:([mineField[mine.xCoordinate + 1][mine.yCoordinate + 1] integerValue] - 1)];
        }
    }
    return mineField;
}

// descriptionメソッド
// => JavaのObject#toString()に相当
- (NSString *)description {
    return @"";
}

@end
