//
//  Runtime.h
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-14.
//

#ifndef RUNTIME_H
#define RUNTIME_H

#import "../Config/Config.h"

@interface Runtime : NSObject

@property (nonatomic) NSString *semver;
@property (nonatomic) Config *config;

- (instancetype)initWithVersion:(NSString *)version andConfig:(Config *)config;

- (int)manual;

- (int)create;

- (int)resolve;

- (int)list;

- (int)execute:(NSString *)key arguments:(NSArray<NSString *> *)arguments;

- (int)version;

@end

#endif
