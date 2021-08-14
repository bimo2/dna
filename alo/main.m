//
//  main.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-10.
//

#import <Foundation/Foundation.h>
#import "Config/Config.h"
#import "Console/Console.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *error;
        ALOConfig *alo = [ALOConfig find:&error];
        
        if (error) {
            [Console error:error.localizedDescription];
            
            return 1;
        }
        
        if (!alo) {
            [Console warning:@"`alo.json` not found" withContext:nil];
            
            return 0;
        }
        
        NSLog(@"ALO Path: %@\n", [alo path]);
        NSLog(@"ALO Version: %li\n", [alo version]);
        NSLog(@"ALO Dependencies: %@\n", [alo dependencies]);
        NSLog(@"ALO Env: %@\n", [alo env]);
        NSLog(@"ALO Scripts: %@\n", [alo scripts]);
    }
    
    return 0;
}
