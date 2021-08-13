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

+ (ALOConfig *)find {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [manager currentDirectoryPath];
    NSString *lastPath = @"";
    NSString *file = nil;
    NSError *error = nil;
    BOOL isGitPath = NO;
    
    while (!file && !isGitPath && ![path isEqualToString:lastPath]) {
        lastPath = path;
        
        NSArray *directory = [manager contentsOfDirectoryAtPath:path error:&error];
        
        if (error) {
            // do something
            return nil;
        }
        
        for (NSString *item in directory) {
            if ([item isEqualToString:fileName]) {
                NSString *absolutePath = [path stringByAppendingPathComponent:item];
                
                file = [NSString stringWithContentsOfFile:absolutePath encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
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
    
    return file ? [self parse:file atPath:lastPath] : nil;
}

+ (ALOConfig *)parse:(NSString *)json atPath:(NSString *)path {
    NSError *error = nil;
    id data = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
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
    config.dependencies = [self parseDependenciesFromObject:object[@"dependencies"]];
    
    if ([object[@"env"] isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *env = object[@"env"];
        
        for (NSString *key in [env allKeys]) {
            if (![env[key] isKindOfClass:[NSString class]]) {
                [env removeObjectForKey:key];
            }
        }
        
        config.env = [NSDictionary dictionaryWithDictionary:env];
    } else {
        config.env = [NSDictionary dictionary];
    }
    
    return config;
}

+ (NSDictionary *)parseDependenciesFromObject:(id)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionary];
    }
    
    NSMutableDictionary *dependencies = [NSMutableDictionary dictionaryWithDictionary:data];
    
    for (NSString *key in [dependencies allKeys]) {
        if ([dependencies[key] isKindOfClass:[NSString class]]) {
            [dependencies setValue:@[dependencies[key]] forKey:key];
        } else if ([dependencies[key] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *array = dependencies[key];
            BOOL isValid = true;
            
            for (NSObject *item in array) {
                if (![item isKindOfClass:[NSString class]]) {
                    isValid = false;
                    
                    break;
                }
            }
            
            if (isValid && [array count] > 0) {
                [dependencies setValue:[NSArray arrayWithArray:array] forKey:key];
            } else {
                [dependencies removeObjectForKey:key];
            }
        } else {
            [dependencies removeObjectForKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dependencies];
}

@end
