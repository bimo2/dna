//
//  Error.h
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-13.
//

#ifndef ERROR_H
#define ERROR_H

enum
{
    DNAReadError = 100,
    DNAWriteError,
    DNAParseError,
    DNARuntimeError,
};

@interface NSError (DNAError)

@property(class, readonly) NSString *domain;

+ (NSError *)error:(NSInteger)code because:(NSString *)reason;

@end

#endif
