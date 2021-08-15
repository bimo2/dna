//
//  Config.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#import <Foundation/Foundation.h>
#import "../Error/Error.h"
#import "Config.h"

@implementation ALOScript
@end

@implementation ALOConfig

static NSString *gitFile = @".git";

+ (NSString *)fileName {
    return @"alo.json";
}

+ (ALOConfig *)find:(NSError **)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [manager currentDirectoryPath];
    NSString *lastPath = @"";
    NSString *file = nil;
    NSError *fsError = nil;
    BOOL isGitPath = NO;
    
    *error = nil;
    
    while (!file && !isGitPath && ![path isEqualToString:lastPath]) {
        lastPath = path;
        
        NSArray *directory = [manager contentsOfDirectoryAtPath:path error:&fsError];
        
        if (fsError) {
            *error = [NSError error:ALOReadError because:@"Could not read directory: %@", path];
            
            return nil;
        }
        
        for (NSString *item in directory) {
            if ([item isEqualToString:[self fileName]]) {
                NSString *absolutePath = [path stringByAppendingPathComponent:item];
                
                file = [NSString stringWithContentsOfFile:absolutePath encoding:NSUTF8StringEncoding error:&fsError];
                
                if (fsError) {
                    *error = [NSError error:ALOReadError because:@"Could not read file: %@", [path stringByAppendingPathComponent:item]];
                    
                    return nil;
                }
                
                break;
            }
            
            if ([item isEqualToString: gitFile]) isGitPath = YES;
        }
        
        path = [path stringByDeletingLastPathComponent];
    }
    
    return file ? [self parse:file atPath:lastPath error:error] : nil;
}

+ (ALOConfig *)parse:(NSString *)json atPath:(NSString *)path error:(NSError **)error {
    NSError *jsonError = nil;
    id data = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (jsonError || ![data isKindOfClass:[NSDictionary class]]) {
        *error = [NSError error:ALOParseError because:@"Invalid JSON {} syntax"];
        
        return nil;
    }
    
    NSDictionary *object = data;
    ALOConfig *config = [[ALOConfig alloc] init];
    
    config.path = [NSString stringWithString:path];
    config.version = [object[@"_alo"] integerValue];
    config.dependencies = [self parseDependenciesFromData:object[@"dependencies"] error:error];
    
    if (*error) return nil;
    
    config.env = [self parseEnvFromData:object[@"env"] error:error];
    
    if (*error) return nil;
    
    config.scripts = [self parseScriptsFromData:object[@"scripts"] error:error];
    
    if (*error) return nil;
    
    return config;
}

+ (ALODependencies *)parseDependenciesFromData:(id)data error:(NSError **)error {
    if (!data) return [ALODependencies dictionary];
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        *error = [NSError error:ALOParseError because:@"Invalid `dependencies` object"];
        
        return nil;
    }
    
    NSMutableDictionary *dependencies = [NSMutableDictionary dictionaryWithDictionary:data];
    
    NSError *(^keyedError)(NSString *) = ^NSError *(NSString *key) {
        return [NSError error:ALOParseError because:@"Invalid `dependencies` object: %@", key];
    };
    
    for (NSString *key in [dependencies allKeys]) {
        if ([dependencies[key] isKindOfClass:[NSString class]]) {
            NSArray *array = @[[NSString stringWithString:dependencies[key]]];
            
            [dependencies setObject:array forKey:key];
            
            continue;
        }
        
        if ([dependencies[key] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *array = dependencies[key];
            
            if ([array count] == 0 || [array count] > 2) {
                *error = keyedError(key);
                
                return nil;
            }
            
            for (NSObject *item in array) {
                if (![item isKindOfClass:[NSString class]]) {
                    *error = keyedError(key);
                    
                    return nil;
                }
            }
            
            continue;
        }
        
        *error = keyedError(key);
        
        return nil;
    }
    
    return [ALODependencies dictionaryWithDictionary:dependencies];
}

+ (ALOEnv *)parseEnvFromData:(id)data error:(NSError **)error {
    if (!data) return [ALOEnv dictionary];
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        *error = [NSError error:ALOParseError because:@"Invalid `env` object"];
        
        return nil;
    }
    
    ALOEnv *env = data;
    
    for (NSString *key in [env allKeys]) {
        if (![env[key] isKindOfClass:[NSString class]]) {
            *error = [NSError error:ALOParseError because:@"Invalid `env` object: %@", key];
            
            return nil;
        }
    }
    
    return env;
}

+ (ALOScripts *)parseScriptsFromData:(id)data error:(NSError **)error {
    if (!data) return [ALOScripts dictionary];
    
    if (![data isKindOfClass:[NSMutableDictionary class]]) {
        *error = [NSError error:ALOParseError because:@"Invalid `scripts` object"];
        
        return nil;
    }
    
    NSMutableDictionary *scripts = data;
    
    NSError *(^keyedError)(NSString *) = ^NSError *(NSString *key) {
        return [NSError error:ALOParseError because:@"Invalid `scripts` object: %@", key];
    };
    
    for (NSString *key in [scripts allKeys]) {
        if (![scripts[key] isKindOfClass:[NSDictionary class]]) {
            *error = keyedError(key);
            
            return nil;
        }
        
        if (scripts[key][@"?"] && ![scripts[key][@"?"] isKindOfClass:[NSString class]]) {
            *error = keyedError(key);
            
            return nil;
        }
        
        if ([scripts[key][@"run"] isKindOfClass:[NSString class]]) {
            ALOScript *script = [[ALOScript alloc] init];
            
            script.info = [NSString stringWithString:scripts[key][@"?"] ?: @""];
            script.run = @[[NSString stringWithString:scripts[key][@"run"]]];
            [scripts setObject:script forKey:key];
            
            continue;
        }
        
        if ([scripts[key][@"run"] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *commands = scripts[key][@"run"];
            
            for (NSObject *item in commands) {
                if (![item isKindOfClass:[NSString class]]) {
                    *error = keyedError(key);
                    
                    return nil;
                }
            }
            
            ALOScript *script = [[ALOScript alloc] init];
            
            script.info = [NSString stringWithString:scripts[key][@"?"] ?: @""];
            script.run = [NSArray arrayWithArray:commands];
            [scripts setObject:script forKey:key];
            
            continue;
        }
        
        *error = keyedError(key);
        
        return nil;
    }
    
    return [NSDictionary dictionaryWithDictionary:scripts];
}

@end
