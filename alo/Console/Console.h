//
//  Console.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-13.
//

#ifndef CONSOLE_H
#define CONSOLE_H

@interface Console : NSObject

+ (void)message:(NSString *)log withContext:(NSString *)context;

+ (void)success:(NSString *)log withContext:(NSString *)context;

+ (void)warning:(NSString *)log withContext:(NSString *)context;

+ (void)error:(NSString *)log;

@end

#endif
