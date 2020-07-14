//
//  Book.h
//  Shelfed
//
//  Created by Clara Kim on 7/14/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSArray *authorsArray;
@property (strong, nonatomic) NSString *authorsString;
@property (strong, nonatomic) NSString *bookDescription;

@property (strong, nonatomic) NSURL *coverArtThumbnail;
@property (strong, nonatomic) NSURL *coverArt;

@property (strong, nonatomic) NSString *publishedDate;
@property (strong, nonatomic) NSString *bookID;
@property (strong, nonatomic) NSString *isbn13;
@property (strong, nonatomic) NSString *isbn10;
@property (strong, nonatomic) NSNumber *pages;

- (id) initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)booksWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
