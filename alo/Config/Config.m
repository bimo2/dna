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

+ (NSString *)find {
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
    
    return file;
}

@end
