//
//  Config.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@implementation ALOScript @end

@implementation ALOConfig

static NSString *fileName = @"alo.json";
static NSString *gitFile = @".git";

+ (ALOConfig *)find:(NSError **)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [manager currentDirectoryPath];
    NSString *lastPath = @"";
    NSString *file = nil;
    BOOL isGitPath = NO;
    
    *error = nil;
    
    while (!file && !isGitPath && ![path isEqualToString:lastPath]) {
        lastPath = path;
        
        NSArray *directory = [manager contentsOfDirectoryAtPath:path error:error];
        
        if (*error) {
            // do something
            return nil;
        }
        
        for (NSString *item in directory) {
            if ([item isEqualToString:fileName]) {
                NSString *absolutePath = [path stringByAppendingPathComponent:item];
                
                file = [NSString stringWithContentsOfFile:absolutePath encoding:NSUTF8StringEncoding error:error];
                
                if (*error) {
                    // do something
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
    id data = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:error];
    
    if (*error) {
        // do something
        return nil;
    }
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        // do something
        return nil;
    }
    
    NSDictionary *object = data;
    ALOConfig *config = [[ALOConfig alloc] init];
    
    config.path = [NSString stringWithString:path];
    config.version = [object[@"_alo"] integerValue];
    config.dependencies = [self parseDependenciesFromData:object[@"dependencies"] error:error];
    
    if (*error) {
        // do something
        return nil;
    }
    
    config.env = [self parseEnvFromData:object[@"env"] error:error];
    
    if (*error) {
        // do something
        return nil;
    }
    
    config.scripts = [self parseScriptsFromData:object[@"scripts"] error:error];
    
    if (*error) {
        // do something
        return nil;
    }
    
    return config;
}

+ (ALODependencies *)parseDependenciesFromData:(id)data error:(NSError **)error {
    if (!data) return [NSDictionary dictionary];
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        // do something
        return nil;
    }
    
    NSMutableDictionary *dependencies = [NSMutableDictionary dictionaryWithDictionary:data];
    
    for (NSString *key in [dependencies allKeys]) {
        if ([dependencies[key] isKindOfClass:[NSString class]]) {
            NSArray *array = @[[NSString stringWithString:dependencies[key]]];
            
            [dependencies setObject:array forKey:key];
            
            continue;
        }
        
        if ([dependencies[key] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *array = dependencies[key];
            
            if ([array count] == 0 || [array count] > 2) {
                // do something
                return nil;
            }
            
            for (NSObject *item in array) {
                if (![item isKindOfClass:[NSString class]]) {
                    // do something
                    return nil;
                }
            }
            
            continue;
        }
        
        // do something
        return nil;
    }
    
    return [NSDictionary dictionaryWithDictionary:dependencies];
}

+ (ALOEnv *)parseEnvFromData:(id)data error:(NSError **)error {
    if (!data) return [NSDictionary dictionary];
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        // do something
        return nil;
    }
    
    NSDictionary *env = data;
    
    for (NSString *key in [env allKeys]) {
        if (![env[key] isKindOfClass:[NSString class]]) {
            // do something
            return nil;
        }
    }
    
    return env;
}

+ (ALOScripts *)parseScriptsFromData:(id)data error:(NSError **)error {
    if (!data) return [NSDictionary dictionary];
    
    if (![data isKindOfClass:[NSMutableDictionary class]]) {
        // do something
        return nil;
    }
    
    NSMutableDictionary *scripts = data;
    
    for (NSString *key in [scripts allKeys]) {
        if (![scripts[key] isKindOfClass:[NSDictionary class]]) {
            // do something
            return nil;
        }
        
        if (![scripts[key][@"?"] isKindOfClass:[NSString class]]) {
            // do something
            return nil;
        }
        
        if ([scripts[key][@"run"] isKindOfClass:[NSString class]]) {
            ALOScript *script = [[ALOScript alloc] init];
            
            script.info = [NSString stringWithString:scripts[key][@"?"]];
            script.run = @[[NSString stringWithString:scripts[key][@"run"]]];
            [scripts setObject:script forKey:key];
            
            continue;
        }
        
        if ([scripts[key][@"run"] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *commands = scripts[key][@"run"];
            
            for (NSObject *command in commands) {
                if (![command isKindOfClass:[NSString class]]) {
                    // do something
                    return nil;
                }
            }
            
            ALOScript *script = [[ALOScript alloc] init];
            
            script.info = [NSString stringWithString:scripts[key][@"?"]];
            script.run = [NSArray arrayWithArray:commands];
            [scripts setObject:script forKey:key];
            
            continue;
        }
        
        // do something
        return nil;
    }
    
    return [NSDictionary dictionaryWithDictionary:scripts];
}

@end
