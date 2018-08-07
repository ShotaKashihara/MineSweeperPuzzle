//
//  Mine.h
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#ifndef Mine_h
#define Mine_h

#import <Foundation/Foundation.h>

/// トリプルスラッシュでコードアシストに説明が乗る

/// 地雷
@interface Mine : NSObject <NSCopying>

/// X座標
@property (nonatomic) NSInteger xCoordinate;
/// Y座標
@property (nonatomic) NSInteger yCoordinate;
/// 座標の値
@property (nonatomic) NSInteger value;

/// コンビニエンスコンストラクタ
+ (Mine *)mineClassWithXCoordinate:(NSInteger)xCoordinate
                       yCoordinate:(NSInteger)yCoordinate
                             value:(NSInteger)value;


/*!
 @method comparePriority:mine
 @abstract 優先度ソート
 @discussion 試行マスを決定するためのソートに使用
 @param mine 比較対象
 @result 比較結果
 */
- (NSComparisonResult) comparePriority:(Mine *)mine;

@end

#endif /* Mine_h */
