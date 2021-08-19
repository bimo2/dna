//
//  Lexer.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-17.
//

#import <Foundation/Foundation.h>
#import "Lexer.h"

@implementation ALOToken

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

@implementation ALOLexer

static NSString *tokenPattern = @"#(?<=#)((\\w+[\?!]?)|(\\w+ -> ([^\\s#]+|\"[^#]+\")))(?=#)#";

+ (NSArray<ALOToken *> *)tokenize:(NSArray<NSString *> *)lines {
    NSMutableArray<ALOToken *> *tokens = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:tokenPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSInteger i = 0; i < [lines count]; i++) {
        NSString *line = [lines objectAtIndex:i];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
        
        for (NSTextCheckingResult *match in matches) {
            ALOToken *token = [[ALOToken alloc] initWithTextMatch:match andLine:line number:i];
            
            [tokens addObject:token];
        }
    }
    
    return [NSArray arrayWithArray:tokens];
}

@end
