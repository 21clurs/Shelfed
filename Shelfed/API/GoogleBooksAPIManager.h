//
//  GoogleBooksAPIManager.h
//  Shelfed
//
//  Created by Clara Kim on 7/14/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleBooksAPIManager : NSObject
@property (nonatomic, strong) NSURLSession *session;
-(id)init;
-(void)defaultHomeQuery: (void(^)(NSArray *books, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END