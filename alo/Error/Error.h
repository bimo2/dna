//
//  Error.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-13.
//

#ifndef ERROR_H
#define ERROR_H

enum {
    ALOReadError = 100,
    ALOWriteError,
    ALOParseError,
};

@interface NSError (ALOError)

@property (class, readonly) NSString *domain;

+ (NSError *)error:(NSInteger)code because:(NSString *)reason, ...;

@end

#endif
