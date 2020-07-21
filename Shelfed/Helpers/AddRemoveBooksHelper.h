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

@end

NS_ASSUME_NONNULL_END
