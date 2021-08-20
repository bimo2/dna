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

+ (NSError *)error:(NSInteger)code because:(NSString *)reason {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: reason,
    };
    
    return [NSError errorWithDomain:[NSError domain] code:code userInfo:userInfo];
}

@end
