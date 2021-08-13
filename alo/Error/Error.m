//
//  Error.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-13.
//

#import <Foundation/Foundation.h>
#import "Error.h"

@implementation NSError (ALOError)

+ (NSString *)domain {
    return @"com.balance.alo";
}

+ (NSError *)error:(NSInteger)code because:(NSString *)reason, ... {
    va_list list;
    va_start(list, reason);
    
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: [[NSString alloc] initWithFormat:reason arguments:list],
    };
    
    va_end(list);
    
    return [NSError errorWithDomain:[self domain] code:code userInfo:userInfo];
}

@end
