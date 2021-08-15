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
        ALOConfig *config = [ALOConfig find:&error];
        
        if (error) {
            [Console error:error.localizedDescription];
            
            return (int) error.code;
        }
        
        ALORuntime *alo = [[ALORuntime alloc] initWithVersion:[ALOResources latestVersion] andConfig:config];
        
        if (argc < 2) {
            return [alo manual];
        }
        
        NSString *script = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        if ([script isEqualToString:@"init"] || [script isEqualToString:@"i"]) {
            return [alo create];
        } else if ([script isEqualToString:@"version"] || [script isEqualToString:@"v"]) {
            return [alo version];
        } else {
            [Console error:[NSString stringWithFormat:@"`%@` not defined", script]];
        }
    }
    
    return 0;
}
