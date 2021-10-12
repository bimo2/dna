//
//  Resources.h
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-15.
//

#ifndef RESOURCES_H
#define RESOURCES_H

@interface Resources : NSObject

@property (class, nonatomic, readonly) NSString *latestVersion;
@property (class, nonatomic, readonly) NSString *docs;

+ (NSString *)jsonWithProject:(NSString *)project;

@end

#endif
