//
//  Config.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@implementation ALOConfig

+ (NSString *) fileName {
    return @"alo.json";
}

+ (NSString *) find {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *directory = [manager contentsOfDirectoryAtPath:[manager currentDirectoryPath] error:nil];
    
    for (NSString *item in directory) {
        if ([item isEqualToString:[self fileName]]) {
            return [NSString stringWithString:item];
        }
    }
    
    return nil;
}

@end
