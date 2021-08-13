//
//  Config.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#ifndef CONFIG_H
#define CONFIG_H

@interface ALOConfig : NSObject

@property (nonatomic) NSString *path;
@property (nonatomic) NSInteger version;
@property (nonatomic) NSDictionary *dependencies;
@property (nonatomic) NSDictionary *env;

+ (ALOConfig *)find:(NSError **)error;

@end

#endif
