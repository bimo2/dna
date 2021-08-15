//
//  Console.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-13.
//

#ifndef CONSOLE_H
#define CONSOLE_H

#define TEXT_RESET "\033[0m"
#define TEXT_BOLD "\033[1m"

@interface Console : NSObject

+ (void)message:(NSString *)log withContext:(NSString *)context;

+ (void)done:(NSString *)log;

+ (void)warning:(NSString *)log;

+ (void)error:(NSString *)log;

+ (void)print:(NSString *)log;

@end

#endif
