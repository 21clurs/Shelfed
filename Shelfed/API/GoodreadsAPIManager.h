//
//  GoodreadsAPI.h
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodreadsAPIManager : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) NSURLSession *session;

@property(nonatomic, strong)NSXMLParser *xmlParser;
@property(nonatomic, strong)NSMutableArray *results;
@property(nonatomic, strong)NSMutableDictionary *bookDict;
@property(nonatomic, strong)NSMutableString *value;


-(id)init;
-(void)defaultHomeQuery: (void(^)(NSArray *works, NSError *error))completion;
-(void)searchWithQuery: (NSString *)search andCompletion: (void(^)(NSArray *works, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
