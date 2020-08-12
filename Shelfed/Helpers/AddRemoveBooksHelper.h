//
//  AddRemoveBooksHelper.h
//  Shelfed
//
//  Created by Clara Kim on 7/20/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddRemoveBooksHelper : NSObject

+ (void)addToFavorites: (Book *)bookID withCompletion:(void(^)(NSError *error))completion;
+ (void)removeFromFavorites: (Book *)bookID withCompletion:(void(^)(NSError *error))completion;
+ (void)getBookForID: (NSString *)bookID withCompletion:(void(^)(Book *book, NSError * _Nullable error)) completion;
+ (void)addBook: (Book *)book toArray:(NSString *)arrayName withCompletion:(void(^)(NSError *error))completion;
+ (void)removeBook: (Book *)book fromArray:(NSString *)arrayName withCompletion:(void(^)(NSError *error))completion;
+ (void)addToParse:(Book *)addBook withCompletion:(void(^)(Book * _Nullable bookToAdd, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
