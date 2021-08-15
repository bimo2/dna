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

@property (nonatomic) ALOConfig *config;

- (instancetype)initWithConfig:(ALOConfig *)config;

- (int)manual;

@end

#endif
