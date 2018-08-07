//
//  Mine.m
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#import "Mine.h"

@implementation Mine

/// コンビニエンスコンストラクタ
+ (Mine *)mineClassWithXCoordinate:(NSInteger)xCoordinate
                       yCoordinate:(NSInteger)yCoordinate
                             value:(NSInteger)value {
    Mine* mine = [[self alloc] init];
    mine.xCoordinate = xCoordinate;
    mine.yCoordinate = yCoordinate;
    mine.value = value;
    return mine;
}

/*!
 @method comparePriority:mine
 @abstract 優先度ソート
 @discussion 試行マスを決定するためのソートに使用
 @param mine 比較対象
 @result 比較結果
 */
- (NSComparisonResult) comparePriority:(Mine *)mine {
    
    if (self.value < mine.value) {
        return NSOrderedDescending;
    } else if (self.value > mine.value) {
        return NSOrderedAscending;
    } else if (self.xCoordinate < mine.xCoordinate) {
        return NSOrderedAscending;
    } else if (self.xCoordinate > mine.xCoordinate) {
        return NSOrderedDescending;
    } else if (self.yCoordinate < mine.yCoordinate) {
        return NSOrderedAscending;
    } else if (self.yCoordinate > mine.yCoordinate) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

/*!
 @method copyWithZone:zone
 @abstract deep copy用の実装
 @param zone 　
 @result コピー結果
 */
- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setXCoordinate:self.xCoordinate];
        [copy setYCoordinate:self.yCoordinate];
        [copy setValue:self.value];
    }
    
    return copy;
}

@end
