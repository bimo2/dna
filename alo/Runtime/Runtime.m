//
//  Runtime.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-14.
//

#import <Foundation/Foundation.h>
#import "../Error/Error.h"
#import "../Console/Console.h"
#import "../Resources/Resources.h"
#import "Runtime.h"

@implementation ALORuntime

- (instancetype)initWithVersion:(NSString *)version andConfig:(ALOConfig *)config {
    if (self = [super init]) {
        _semver = version;
        _config = config;
    }
    
    return self;
}

- (int)manual {
    if ([self config]) {
        [Console message:[NSString stringWithFormat:@"Ready! (scope: %@)\n", [[self config] path]] withContext:nil];
        [Console print:@"- " TEXT_BOLD "deps, ..." TEXT_RESET];
        [Console print:@"  Resolve software dependencies\n"];
        [Console print:@"- " TEXT_BOLD "list, ls" TEXT_RESET];
        [Console print:@"  List project scripts\n"];
    } else {
        [Console message:@"Not ready...\n" withContext:nil];
        [Console print:@"- " TEXT_BOLD "init, i" TEXT_RESET];
        [Console print:@"  Create `alo.json` template\n"];
    }
    
    [Console print:@"- " TEXT_BOLD "version, v" TEXT_RESET];
    [Console print:@"  Get version info\n"];
    
    return 0;
}

- (int)create {
    if ([self config]) {
        [Console warning:[NSString stringWithFormat:@"`%@` already in scope: %@", [ALOConfig fileName], [[self config] path]]];
        
        return 0;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [[manager currentDirectoryPath] stringByAppendingPathComponent:[ALOConfig fileName]];
    NSError *error;
    
    [manager createFileAtPath:path contents:nil attributes:nil];
    [[ALOResources example] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        [Console error:[NSString stringWithFormat:@"Could not create file: %@", path]];
        
        return ALOWriteError;
    }
    
    [Console done:[NSString stringWithFormat:@"Created new `%@` file!", [ALOConfig fileName]]];
    
    return 0;
}

- (int)version {
    #if __LP64__
    NSString *arch = @"64-bit";
    #else
    NSString *arch = @"32-bit";
    #endif
    
    [Console message:[NSString stringWithFormat:@"version %@ (%@)", [self semver], arch] withContext:nil];
    
    return 0;
}

@end
