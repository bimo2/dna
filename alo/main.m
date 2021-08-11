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
        ALOConfig *alo = [ALOConfig find];
        
        NSLog(@"ALO Path: %@\n", alo.path);
        NSLog(@"ALO Version: %li\n", alo.version);
    }
    
    return 0;
}
