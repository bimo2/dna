//
//  Config.h
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#ifndef CONFIG_H
#define CONFIG_H

typedef NSDictionary<NSString *, NSArray<NSString *> *> ALODependencies;
typedef NSDictionary<NSString *, NSString *> ALOEnv;

@interface ALOScript : NSObject

@property (nonatomic) NSString *info;
@property (nonatomic) NSArray *run;

@end

typedef NSDictionary<NSString *, ALOScript *> ALOScripts;

@interface ALOConfig : NSObject

@property (nonatomic) NSString *path;
@property (nonatomic) NSInteger version;
@property (nonatomic) ALODependencies *dependencies;
@property (nonatomic) ALOEnv *env;
@property (nonatomic) ALOScripts *scripts;

+ (ALOConfig *)find:(NSError **)error;

@end

#endif
