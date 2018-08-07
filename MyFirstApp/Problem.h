//
//  Problem.h
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#ifndef Problem_h
#define Problem_h

#import <Foundation/Foundation.h>

// 定数の命名規則は３つ
// 1. 先頭にkをつけ、単語の先頭の文字を大文字にする。
extern const NSInteger kMineFieldColumnLength;
extern const NSInteger kMineFieldRowLength;

@interface Problem : NSObject

// 2. prefixに自アプリ名の大文字３つ(MyFirstApp -> MFA)をつける
+ (NSArray *)MFAMineField;

// 3. 全て大文字で記述し、単語と単語の間に_を入れる
// static const NSInteger INTEGER_CONSTANT_VALUE = 1;

@end

#endif /* Problem_h */
