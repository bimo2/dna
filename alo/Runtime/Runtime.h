//
//  Runtime.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-14.
//

#ifndef RUNTIME_H
#define RUNTIME_H

#import "../Config/Config.h"

@interface ALORuntime : NSObject

@property (nonatomic) NSString *semver;
@property (nonatomic) ALOConfig *config;

- (instancetype)initWithVersion:(NSString *)version andConfig:(ALOConfig *)config;

- (int)manual;

- (int)create;

- (int)resolve;

- (int)list;

- (int)version;

@end

#endif
