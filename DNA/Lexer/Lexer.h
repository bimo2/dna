//
//  Lexer.h
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-17.
//

#ifndef LEXER_H
#define LEXER_H

#import "../Config/Config.h"

@interface Token : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL required;
@property (nonatomic) NSString *defaultValue;
@property (nonatomic) NSInteger line;
@property (nonatomic) NSRange range;

- (instancetype)initWithTextMatch:(NSTextCheckingResult *)match andLine:(NSString *)line number:(NSInteger)index;

@end

@interface Lexer : NSObject

+ (NSArray<NSString *> *)compile:(NSArray<NSString *> *)lines env:(Env *)env arguments:(NSArray<NSString *> *)arguments error:(NSError **)error;

+ (NSArray<Token *> *)tokenize:(NSArray<NSString *> *)lines;

@end

#endif
