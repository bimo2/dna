//
//  Runtime.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-14.
//

#import <Foundation/Foundation.h>
#import "../Console/Console.h"
#import "Runtime.h"

@implementation ALORuntime

- (instancetype)initWithConfig:(ALOConfig *)config {
    if (self = [super init]) _config = config;
    
    return self;
}

- (int)manual {
    if ([self config]) {
        [Console message:@"Ready!\n" withContext:nil];
        [Console print:@"- " TEXT_BOLD "deps, ..." TEXT_RESET];
        [Console print:@"  Resolve software dependencies\n"];
        [Console print:@"- " TEXT_BOLD "list, ls" TEXT_RESET];
        [Console print:@"  List project scripts\n"];
    } else {
        [Console message:@"Not ready!\n" withContext:nil];
        [Console print:@"- " TEXT_BOLD "init, i" TEXT_RESET];
        [Console print:@"  Create `alo.json` template\n"];
    }
    
    [Console print:@"- " TEXT_BOLD "version, v" TEXT_RESET];
    [Console print:@"  Get version info\n"];
    
    return 0;
}

@end
