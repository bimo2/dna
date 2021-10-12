//
//  Lexer.m
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-17.
//

#import <Foundation/Foundation.h>
#import "../Error/Error.h"
#import "Lexer.h"

@implementation Token

static NSString *keywordPattern = @"\\w+[\?|!]?";
static NSString *valuePattern = @"(?<= -> )(.*?)(?=#)";

- (instancetype)initWithTextMatch:(NSTextCheckingResult *)match andLine:(NSString *)line number:(NSInteger)index {
    if (self = [super init]) {
        NSRegularExpression *nameRegex = [NSRegularExpression regularExpressionWithPattern:keywordPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *nameMatch = [nameRegex firstMatchInString:line options:0 range:[match range]];
        NSString *name = [line substringWithRange:[nameMatch range]];
        
        if ([name hasSuffix:@"!"]) {
            _name = [name substringToIndex:[name length] - 1];
            _required = true;
            _defaultValue = nil;
        } else if ([name hasSuffix:@"?"]) {
            _name = [name substringToIndex:[name length] - 1];
            _required = false;
            _defaultValue = nil;
        } else {
            _name = name;
            _required = false;
            
            NSRegularExpression *valueRegex = [NSRegularExpression regularExpressionWithPattern:valuePattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *valueMatch = [valueRegex firstMatchInString:line options:0 range:[match range]];
            
            _defaultValue = [valueMatch range].length > 0 ? [line substringWithRange:[valueMatch range]] : nil;
        }
        
        _line = index;
        _range = [match range];
    }
    
    return self;
}

@end

@implementation Lexer

static NSString *tokenPattern = @"#(?<=#)((\\w+[\?!]?)|(\\w+ -> ([^\\s#]+|\"[^#]+\")))(?=#)#";
static NSString *whitespacePattern = @"\\s\\s+(?=(?:[^\"]*(\")[^\"]*\\1)*[^\"]*$)";
static NSString *skip = @"-";

+ (NSArray<NSString *> *)compile:(NSArray<NSString *> *)lines env:(Env *)env arguments:(NSArray<NSString *> *)arguments error:(NSError **)error {
    NSMutableArray<NSString *> *instructions = [NSMutableArray arrayWithArray:lines];
    
    for (NSString *key in env) {
        NSString *replace = [NSString stringWithFormat:@"&%@", key];
        NSString *value = env[key];
        
        for (NSInteger i = 0; i < [instructions count]; i++) {
            NSString *update = [instructions[i] stringByReplacingOccurrencesOfString:replace withString:value];
            
            [instructions replaceObjectAtIndex:i withObject:update];
        }
    }
    
    NSArray<Token *> *tokens = [Lexer tokenize:instructions];
    
    for (NSInteger i = 0; i < [tokens count]; i++) {
        NSInteger index = [tokens count] - (i + 1);
        Token *token = [tokens objectAtIndex:index];
        NSString *argument = [arguments count] > index ? [arguments objectAtIndex:index] : skip;
        
        if (![argument isEqualToString:skip]) {
            NSString *string = [argument containsString:@" "] ? [NSString stringWithFormat:@"\"%@\"", argument] : argument;
            NSString *update = [instructions[[token line]] stringByReplacingCharactersInRange:[token range] withString:string];
            
            [instructions replaceObjectAtIndex:[token line] withObject:update];
            
            continue;
        }
        
        if ([token required]) {
            *error = [NSError error:DNARuntimeError because:[NSString stringWithFormat:@"Expected token: %@", [token name]]];
            
            return nil;
        }
        
        if ([token defaultValue]) {
            NSString *update = [instructions[[token line]] stringByReplacingCharactersInRange:[token range] withString:[token defaultValue]];
            
            [instructions replaceObjectAtIndex:[token line] withObject:update];
            
            continue;
        }
        
        NSString *update = [instructions[[token line]] stringByReplacingCharactersInRange:[token range] withString:@""];
        
        [instructions replaceObjectAtIndex:[token line] withObject:update];
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:whitespacePattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSMutableString *instruction in instructions) {
        [regex replaceMatchesInString:instruction options:0 range:NSMakeRange(0, [instruction length]) withTemplate:@" "];
    }
    
    return [NSArray arrayWithArray:instructions];
}

+ (NSArray<Token *> *)tokenize:(NSArray<NSString *> *)lines {
    NSMutableArray<Token *> *tokens = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:tokenPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSInteger i = 0; i < [lines count]; i++) {
        NSString *line = [lines objectAtIndex:i];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
        
        for (NSTextCheckingResult *match in matches) {
            Token *token = [[Token alloc] initWithTextMatch:match andLine:line number:i];
            
            [tokens addObject:token];
        }
    }
    
    return [NSArray arrayWithArray:tokens];
}

@end
