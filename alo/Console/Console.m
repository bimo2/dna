//
//  Console.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-13.
//

#import <Foundation/Foundation.h>
#import "Console.h"

@implementation Console 

+ (void)message:(NSString *)log withContext:(NSString *)context {
    printf("\033[1;94m%s\033[0;94m %s\033[0m\n", [[context ?: @"ALO" uppercaseString] UTF8String], [log UTF8String]);
}

+ (void)success:(NSString *)log withContext:(NSString *)context {
    printf("\033[1;92m%s\033[0;92m %s\033[0m\n", [[context ?: @"SUCCESS" uppercaseString] UTF8String], [log UTF8String]);
}

+ (void)warning:(NSString *)log withContext:(NSString *)context {
    printf("\033[1;93m%s\033[0;93m %s\033[0m\n", [[context ?: @"WARNING" uppercaseString] UTF8String], [log UTF8String]);
}

+ (void)error:(NSString *)log {
    printf("\033[1;91mERROR\033[0;91m %s\033[0m\n", [log UTF8String]);
}

@end
