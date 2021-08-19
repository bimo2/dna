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
#import "../Lexer/Lexer.h"
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
        [Console print:@"+ " TEXT_BOLD "deps, ..." TEXT_RESET];
        [Console print:@"  Resolve software dependencies\n"];
        [Console print:@"+ " TEXT_BOLD "list, ls" TEXT_RESET];
        [Console print:@"  List project scripts\n"];
    } else {
        [Console message:@"Not ready...\n" withContext:nil];
        [Console print:@"+ " TEXT_BOLD "init, i" TEXT_RESET];
        [Console print:@"  Create `alo.json` template\n"];
    }
    
    [Console print:@"+ " TEXT_BOLD "version, v" TEXT_RESET];
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

- (int)resolve {
    if (![self config]) {
        [Console warning:[NSString stringWithFormat:@"`%@` not in scope", [ALOConfig fileName]]];
        
        return 0;
    }
    
    ALODependencies *dependencies = [[self config] dependencies];
    
    if (![dependencies count]) {
        [Console print:@TEXT_BOLD "\u2713 No dependencies"];
        
        return 0;
    }
    
    for (NSString *key in dependencies) {
        NSString *target = [dependencies[key] firstObject];
        NSInteger status;
        
        if ([target isAbsolutePath]) {
            status = ![[NSFileManager defaultManager] fileExistsAtPath:target];
        } else {
            status = system([[NSString stringWithFormat:@"sh -c \"which -s %@\"", target] UTF8String]);
        }
        
        if (status == 0) {
            [Console print:[NSString stringWithFormat:@TEXT_BOLD TEXT_GREEN "\u2713 %@" TEXT_RESET, key]];
        } else if ([dependencies[key] count] > 1) {
            [Console print:[NSString stringWithFormat:@TEXT_BOLD TEXT_RED "\u2717 %@" TEXT_RESET TEXT_RED ": %@" TEXT_RESET, key, [dependencies[key] objectAtIndex:1]]];
        } else {
            [Console print:[NSString stringWithFormat:@TEXT_BOLD TEXT_RED "\u2717 %@" TEXT_RESET, key]];
        }
    }
    
    return 0;
}

- (int)list {
    if (![self config]) {
        [Console warning:[NSString stringWithFormat:@"`%@` not in scope", [ALOConfig fileName]]];
        
        return 0;
    }
    
    ALOScripts *scripts = [[self config] scripts];
    
    [Console message:[NSString stringWithFormat:@"%lu script%@", [scripts count], [scripts count] == 1 ? @"" : @"s"] withContext:nil];
    
    if ([scripts count] > 0) {
        NSArray<NSString *> *keys = [[scripts allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        for (NSString *key in keys) {
            ALOScript *script = scripts[key];
            NSArray<ALOToken *> *tokens = [ALOLexer tokenize:[script run]];
            NSMutableArray<NSString *> *signature = [NSMutableArray array];
            
            for (ALOToken *token in tokens) {
                NSString *format = [token required] ? @"%@!" : @"%@?";
                
                [signature addObject:[NSString stringWithFormat:format, [token name]]];
            }
            
            [Console print:[NSString stringWithFormat:@"\n- " TEXT_BOLD "%@ %@" TEXT_RESET, key, [signature componentsJoinedByString:@" "]]];
            
            if ([script info]) [Console print:[NSString stringWithFormat:@"  %@", [script info]]];
        }
        
        [Console print:@""];
    }
    
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
