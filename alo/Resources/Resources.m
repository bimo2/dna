//
//  Resources.m
//  alo
//
//  Created by Bimal Bhagrath on 2021-08-15.
//

#import <Foundation/Foundation.h>
#import "Resources.h"

#define ALO_PATH "/usr/local/bin/alo"
#define ALO_URL "https://alo.sh"
#define SAFARI_PATH "/Applications/Safari.app"
#define SAFARI_URL "https://apple.com/safari"
#define XCODE_BINARY "xcodebuild"
#define XCODE_URL "https://developer.apple.com/xcode"

@implementation ALOResources

+ (NSString *)latestVersion {
    return @"0.1.0";
}

+ (NSString *)docs {
    return @ALO_URL;
}

+ (NSString *)jsonWithProject:(NSString *)project {
    NSString *template = @"{\n"
    "  \"_alo\": 0,\n"
    "  \"project\": %s,\n"
    "  \"dependencies\": {\n"
    "    \"ALO\": \"" ALO_PATH "\",\n"
    "    \"Safari\": [\"" SAFARI_PATH "\", \"" SAFARI_URL "\"],\n"
    "    \"Xcode\": [\"" XCODE_BINARY "\", \"" XCODE_URL "\"]\n"
    "  },\n"
    "  \"env\": {\n"
    "    \"TARGET\": \"debug\",\n"
    "    \"PORT\": \"6000\"\n"
    "  },\n"
    "  \"scripts\": {\n"
    "    \"docs\": {\n"
    "      \"?\": \"Open ALO docs\",\n"
    "      \"run\": \"open -a Safari " ALO_URL "\"\n"
    "    },\n"
    "    \"install\": {\n"
    "      \"?\": \"Install...\",\n"
    "      \"run\": [\n"
    "        \"echo -e download dependencies\",\n"
    "        \"echo -e install #path -> /usr/local/bin#\"\n"
    "      ]\n"
    "    },\n"
    "    \"build\": {\n"
    "      \"?\": \"Build...\",\n"
    "      \"run\": [\n"
    "        \"echo -e compile --&TARGET\",\n"
    "        \"echo -e package #binary!#\"\n"
    "      ]\n"
    "    },\n"
    "    \"dev\": {\n"
    "      \"?\": \"Develop...\",\n"
    "      \"run\": \"echo -e start server :&PORT\"\n"
    "    },\n"
    "    \"test\": {\n"
    "      \"?\": \"Test...\",\n"
    "      \"run\": \"echo -e unit-test #file?#\"\n"
    "    }\n"
    "  }\n"
    "}\n";
    
    return [NSString stringWithFormat:template, [project ?: @"null" cStringUsingEncoding:NSUTF8StringEncoding]];
}

@end
