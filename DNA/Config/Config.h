//
//  Config.h
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-11.
//

#ifndef CONFIG_H
#define CONFIG_H

typedef NSDictionary<NSString *, NSArray<NSString *> *> Dependencies;
typedef NSDictionary<NSString *, NSString *> Env;

@interface Script : NSObject

@property (nonatomic) NSString *info;
@property (nonatomic) NSArray<NSString *> *run;

- (instancetype)initWithInfo:(NSString *)info andRun:(NSArray<NSString *> *)run;

@end

typedef NSDictionary<NSString *, Script *> Scripts;

@interface Config : NSObject

@property (class, nonatomic, readonly) NSString *fileName;
@property (nonatomic) NSString *path;
@property (nonatomic) NSInteger version;
@property (nonatomic) NSString *project;
@property (nonatomic) Dependencies *dependencies;
@property (nonatomic) Env *env;
@property (nonatomic) Scripts *scripts;

+ (Config *)find:(NSError **)error;

@end

#endif
