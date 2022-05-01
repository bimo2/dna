//
//  Resources.m
//  DNA
//
//  Created by Bimal Bhagrath on 2021-08-15.
//

#import <Foundation/Foundation.h>
#import "Resources.h"

#define DNA_BINARY "_"
#define DNA_URL "https://github.com/bimo2/dna"
#define SAFARI_PATH "/Applications/Safari.app"
#define XCODE_BINARY "xcodebuild"

@implementation Resources

+ (NSString *)latestVersion {
    return @"0.2.1";
}

+ (NSString *)docs {
    return @DNA_URL;
}

+ (NSString *)jsonWithProject:(NSString *)project {
    NSString *template = @"{\n"
    "  \"_dna\": 0,\n"
    "  \"project\": %s,\n"
    "  \"dependencies\": {\n"
    "    \"DNA\": \"" DNA_BINARY "\",\n"
    "    \"Safari\": \"" SAFARI_PATH "\",\n"
    "    \"Xcode\": \"" XCODE_BINARY "\"\n"
    "  },\n"
    "  \"env\": {\n"
    "    \"TARGET\": \"debug\",\n"
    "    \"PORT\": \"6000\"\n"
    "  },\n"
    "  \"scripts\": {\n"
    "    \"docs\": {\n"
    "      \"?\": \"Open DNA docs\",\n"
    "      \"run\": \"open -a Safari " DNA_URL "\"\n"
    "    },\n"
    "    \"install\": {\n"
    "      \"?\": \"Install...\",\n"
    "      \"run\": [\n"
    "        \"echo download dependencies\",\n"
    "        \"echo install #path -> /usr/local/bin#\"\n"
    "      ]\n"
    "    },\n"
    "    \"build\": {\n"
    "      \"?\": \"Build...\",\n"
    "      \"run\": [\n"
    "        \"echo compile --&TARGET\",\n"
    "        \"echo package #binary!#\"\n"
    "      ]\n"
    "    },\n"
    "    \"start\": {\n"
    "      \"?\": \"Start...\",\n"
    "      \"run\": \"echo start server :&PORT\"\n"
    "    },\n"
    "    \"test\": {\n"
    "      \"?\": \"Test...\",\n"
    "      \"run\": \"echo unit-test #file?#\"\n"
    "    }\n"
    "  }\n"
    "}\n";
    
    return [NSString stringWithFormat:template, [project ?: @"null" cStringUsingEncoding:NSUTF8StringEncoding]];
}

@end
