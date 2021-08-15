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
        
        ALORuntime *alo = [[ALORuntime alloc] initWithConfig:config];
        
        if (argc < 2) {
            return [alo manual];
        }
    }
    
    return 0;
}
