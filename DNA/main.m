//
//  main.m
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-10.
//

#import <Foundation/Foundation.h>
#import "Console/Console.h"
#import "Resources/Resources.h"
#import "Config/Config.h"
#import "Runtime/Runtime.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSError *error;
        Config *dna = [Config find:&error];
        
        if (error) {
            [Console error:[error localizedDescription]];
            
            return (int) [error code];
        }
        
        Runtime *app = [[Runtime alloc] initWithVersion:[Resources latestVersion] andConfig:dna];
        
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
            NSMutableArray *arguments = [NSMutableArray array];
            
            for (int i = 2; i < argc; i++) {
                [arguments addObject:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
            }
            
            return [app execute:script arguments:arguments];
        }
    }
    
    return 0;
}
