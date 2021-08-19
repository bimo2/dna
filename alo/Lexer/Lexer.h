//
//  Lexer.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-17.
//

#ifndef LEXER_H
#define LEXER_H

#import "../Config/Config.h"

@interface ALOToken : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL required;
@property (nonatomic) NSString *defaultValue;
@property (nonatomic) NSInteger line;
@property (nonatomic) NSRange range;

- (instancetype)initWithTextMatch:(NSTextCheckingResult *)match andLine:(NSString *)line number:(NSInteger)index;

@end

@interface ALOLexer : NSObject

+ (NSArray<NSString *> *)compile:(NSArray<NSString *> *)lines env:(ALOEnv *)env arguments:(NSArray<NSString *> *)arguments;

+ (NSArray<ALOToken *> *)tokenize:(NSArray<NSString *> *)lines;

@end

#endif
