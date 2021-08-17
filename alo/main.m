//
//  main.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-10.
//

#import <Foundation/Foundation.h>
#import "Console/Console.h"
#import "Resources/Resources.h"
#import "Config/Config.h"
#import "Runtime/Runtime.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *error;
        ALOConfig *alo = [ALOConfig find:&error];
        
        if (error) {
            [Console error:error.localizedDescription];
            
            return (int) error.code;
        }
        
        ALORuntime *app = [[ALORuntime alloc] initWithVersion:[ALOResources latestVersion] andConfig:alo];
        
        if (argc < 2) return [app manual];
        
        NSString *script = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        if ([script isEqualToString:@"init"] || [script isEqualToString:@"i"]) {
            return [app create];
        } else if ([script isEqualToString:@"deps"] || [script isEqualToString:@"..."]) {
            return [app resolve];
        } else if ([script isEqualToString:@"version"] || [script isEqualToString:@"v"]) {
            return [app version];
        } else if ([script isEqualToString:@"list"] || [script isEqualToString:@"ls"]) {
            return [app list];
        } else {
            [Console error:[NSString stringWithFormat:@"`%@` not defined", script]];
        }
    }
    
    return 0;
}
