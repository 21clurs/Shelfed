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
-(void)logout;
-(void)searchBooks: (NSString *)searchString andCompletion:(void(^)(NSArray *books, NSError *error))completion;
-(void)reloadBooksAuthor:(nullable NSString *)author withCompletion:(void(^)(NSArray *books, NSError *error))completion;
-(void)loadMoreBooks: (void(^)(NSArray *books, NSError *error))completion;
-(void)getBookWithBookID: (NSString *)bookID andCompletion: (void(^)(NSDictionary *bookDict, NSError *error))completion;
-(void)getBooksForAuthors: (NSString *)authorsString andCompletion: (void(^)(NSArray *books, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
