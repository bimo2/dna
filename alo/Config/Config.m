//
//  Config.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#import <Foundation/Foundation.h>
#import "Config.h"

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
            
            if ([item isEqualToString: gitFile]) {
                isGitPath = YES;
            }
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
    
    return config;
}

+ (NSDictionary *)parseDependenciesFromData:(id)data error:(NSError **)error {
    if (!data) {
        return [NSDictionary dictionary];
    }
    
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
        
        return nil;
    }
    
    return [NSDictionary dictionaryWithDictionary:dependencies];
}

+ (NSDictionary *)parseEnvFromData:(id)data error:(NSError **)error {
    if (!data) {
        return [NSDictionary dictionary];
    }
    
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

@end
