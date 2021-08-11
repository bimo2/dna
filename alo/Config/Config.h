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

+ (ALOConfig *)find;
+ (ALOConfig *)parse:(NSString *)json atPath:(NSString *)path;

@end

#endif
