//
//  main.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-10.
//

#import <Foundation/Foundation.h>
#import "Config/Config.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *error;
        ALOConfig *alo = [ALOConfig find:&error];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
            return 1;
        }
        
        if (alo) {
            NSLog(@"ALO Path: %@\n", [alo path]);
            NSLog(@"ALO Version: %li\n", [alo version]);
            NSLog(@"ALO Dependencies: %@\n", [alo dependencies]);
            NSLog(@"ALO Env: %@\n", [alo env]);
            NSLog(@"ALO Scripts: %@\n", [alo scripts]);
        }
    }
    
    return 0;
}
