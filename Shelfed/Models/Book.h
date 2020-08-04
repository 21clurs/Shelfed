//
//  Book.h
//  Shelfed
//
//  Created by Clara Kim on 7/14/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *authorsString;
@property (strong, nonatomic) NSString *bookID;

@property (strong, nonatomic) NSString *coverArtThumbnail;

@property (strong, nonatomic) NSDate *publishedDate;
//@property (strong, nonatomic) NSString *printType;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSNumber *pages;


- (id) initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)booksWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
