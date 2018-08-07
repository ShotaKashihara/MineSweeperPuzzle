//
//  Solve.h
//  MyFirstApp
//
//  Created by Shota on 2016/11/14.
//
//

#ifndef Solve_h
#define Solve_h

#import <Foundation/Foundation.h>

// C言語のimportと同義
#import "Problem.h"
#import "SweepHistory.h"

@interface Solve : NSObject // クラス名

// プロパティ定義
// (基本的にnonatomicを指定)
// (NSStringやNSArrayなど、NSMutable~なサブクラスがある型はcopyを追加)
// (WeakReference:弱参照 を使用したい場合は、weakを追加)
// NSString : プロパティの型
// *name: 変数名
//        .mファイルでは、「_sweepHistory」か「self.sweepHistory」でアクセス可能
//        setName()などのアクセサは定義不要
//@property (nonatomic) SweepHistory *sweepHistory; // プロパティ定義

// 関数宣言(headerファイルに宣言する関数は全てpublic扱い)
//       (privateな関数はmファイルに記述するのみ)
// - : インスタンスメソッド( ≠ private )
// + : クラスメソッド ( Javaのstatic修飾子と同義 )
// (void) : 戻り値の型
- (NSArray *)exec:(NSArray *)mineField;

@end

#endif /* Solve_h */
