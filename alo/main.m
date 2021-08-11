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
        NSString *aloPath = [ALOConfig find];
        
        NSLog(@"ALO Path: %@\n", aloPath);
    }
    
    return 0;
}
