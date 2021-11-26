//
//  Runtime.m
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-14.
//

#import <Foundation/Foundation.h>
#import "../Error/Error.h"
#import "../Console/Console.h"
#import "../Resources/Resources.h"
#import "../Lexer/Lexer.h"
#import "Runtime.h"

#define GITHUB_DIRECTORY "github.com"

@implementation Runtime

- (instancetype)initWithVersion:(NSString *)version andConfig:(Config *)config {
    if (self = [super init]) {
        _semver = version;
        _config = config;
    }
    
    return self;
}

- (int)manual {
    if ([self config]) {
        if ([[self config] project]) {
            [Console message:[NSString stringWithFormat:@"Ready! (scope: " TEXT_BOLD "%@" TEXT_RESET TEXT_BLUE ")\n", [[self config] project]] withContext:nil];
        } else {
            [Console message:[NSString stringWithFormat:@"Ready! (scope: %@)\n", [[self config] path]] withContext:nil];
        }
        
        [Console print:@"+ " TEXT_BOLD "deps, ..." TEXT_RESET];
        [Console print:@"  Resolve software dependencies\n"];
        [Console print:@"+ " TEXT_BOLD "list, ls" TEXT_RESET];
        [Console print:@"  List project scripts\n"];
    } else {
        [Console message:@"Not ready...\n" withContext:nil];
        [Console print:@"+ " TEXT_BOLD "init, i" TEXT_RESET];
        [Console print:@"  Create `dna.json` template\n"];
    }
    
    [Console print:@"+ " TEXT_BOLD "version, v" TEXT_RESET];
    [Console print:@"  Get version info\n"];
    
    return 0;
}

- (int)create {
    if ([self config]) {
        [Console warning:[NSString stringWithFormat:@"`%@` already in scope: %@", [Config fileName], [[self config] project] ?: [[self config] path]]];
        
        return 0;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [[manager currentDirectoryPath] stringByAppendingPathComponent:[Config fileName]];
    NSArray<NSString *> *components = [[path stringByDeletingLastPathComponent] componentsSeparatedByString:@"/"];
    NSInteger githubDirectory = [components indexOfObject:@GITHUB_DIRECTORY];
    NSString *project = @"null";
    NSError *error;
    
    [manager createFileAtPath:path contents:nil attributes:nil];
    
    if (githubDirectory != NSNotFound && [components count] > githubDirectory + 2) {
        project = [NSString stringWithFormat:@"\"%@/%@\"", components[++githubDirectory], components[++githubDirectory]];
    } else {
        [Console message:@"Enter project name:" withContext:nil];
        
        NSFileHandle *handle = [NSFileHandle fileHandleWithStandardInput];
        NSString *input = [[NSString alloc] initWithData:[handle availableData] encoding:NSUTF8StringEncoding];
        NSString *draft = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (![draft isEqualToString:[NSString string]]) project = [NSString stringWithFormat:@"\"%@\"", draft];
    }
    
    [[Resources jsonWithProject:project] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        [Console error:[NSString stringWithFormat:@"Could not create file: %@", path]];
        
        return DNAWriteError;
    }
    
    [Console done:[NSString stringWithFormat:@"Created new `%@` file!", [Config fileName]]];
    
    return 0;
}

- (int)resolve {
    if (![self config]) {
        [Console warning:[NSString stringWithFormat:@"`%@` not in scope", [Config fileName]]];
        
        return 0;
    }
    
    Dependencies *dependencies = [[self config] dependencies];
    
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
            status = system([[NSString stringWithFormat:@"sh -c 'which -s %@'", target] UTF8String]);
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
        [Console warning:[NSString stringWithFormat:@"`%@` not in scope", [Config fileName]]];
        
        return 0;
    }
    
    Scripts *scripts = [[self config] scripts];
    NSString *suffix = [scripts count] == 1 ? @"" : @"s";
    
    [Console message:[NSString stringWithFormat:@"%lu script%@", [scripts count], suffix] withContext:nil];
    
    if ([scripts count] > 0) {
        NSArray<NSString *> *keys = [[scripts allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        for (NSString *key in keys) {
            Script *script = scripts[key];
            NSArray<Token *> *tokens = [Lexer tokenize:[script run]];
            NSMutableArray<NSString *> *signature = [NSMutableArray array];
            
            for (Token *token in tokens) {
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

- (int)execute:(NSString *)key arguments:(NSArray<NSString *> *)arguments {
    Script *script = [[self config] scripts][key];
    
    if (!script) {
        [Console error:[NSString stringWithFormat:@"`%@` not defined", key]];
        
        return DNARuntimeError;
    }
    
    NSError *error = nil;
    NSDate *start = [NSDate date];
    NSArray<NSString *> *instructions = [Lexer compile:[script run] env:[[self config] env] arguments:arguments error:&error];
    
    if (error) {
        [Console error:[error localizedDescription]];
        
        return (int) [error code];
    }
    
    for (NSString *instruction in instructions) {
        [Console message:instruction withContext:key];
        
        NSInteger status = system([[NSString stringWithFormat:@"sh -c '%@'", instruction] UTF8String]);
        
        if (status != 0) {
            [Console error:[NSString stringWithFormat:@"Exit code: %li", status]];
            
            return (int) status;
        }
    }
    
    NSNumber *elapsed = [NSNumber numberWithDouble:[start timeIntervalSinceNow] * -1];
    
    [Console done:[NSString stringWithFormat:@"%.3fs", [elapsed doubleValue]]];
    
    return 0;
}

- (int)version {
#if TARGET_CPU_ARM64
    NSString *arch = @"Apple";
#elif TARGET_CPU_X86_64
    NSString *arch = @"Intel";
#endif
    
    [Console message:[NSString stringWithFormat:@"version %@ (%@)", [self semver], arch] withContext:nil];
    
    return 0;
}

@end
