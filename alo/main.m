//
//  main.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-10.
//

#import <Foundation/Foundation.h>
#import "Config/Config.h"
#import "Runtime/Runtime.h"
#import "Console/Console.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *error;
        ALOConfig *config = [ALOConfig find:&error];
        
        if (error) {
            [Console error:error.localizedDescription];
            
            return 1;
        }
        
        NSString *version = @"0.1.0";
        ALORuntime *alo = [[ALORuntime alloc] initWithVersion:version andConfig:config];
        
        if (argc < 2) {
            return [alo manual];
        }
        
        NSString *script = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        
        if ([script isEqualToString:@"version"] || [script isEqualToString:@"v"]) {
            return [alo version];
        } else {
            [Console error:[NSString stringWithFormat:@"`%@` not defined", script]];
        }
    }
    
    return 0;
}
