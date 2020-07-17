//
//  Book.m
//  Shelfed
//
//  Created by Clara Kim on 7/14/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "Book.h"

@implementation Book

@dynamic title;
@dynamic subtitle;
@dynamic authorsArray;
@dynamic authorsString;
@dynamic bookDescription;

@dynamic coverArtThumbnail;
@dynamic coverArt;

@dynamic publishedDate;
@dynamic bookID;
@dynamic isbn13;
@dynamic isbn10;
@dynamic pages;

+ (nonnull NSString *)parseClassName {
    return @"Book";
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    self.bookID = dictionary[@"id"];
    
    NSDictionary *volumeInfo = dictionary[@"volumeInfo"];
    self.title = volumeInfo[@"title"];
    
    if(volumeInfo[@"subtitle"]!=nil){
        self.subtitle = volumeInfo[@"subtitle"];
    }
    if(volumeInfo[@"authors"]!=nil){
        self.authorsArray = volumeInfo[@"authors"];
        self.authorsString = [volumeInfo[@"authors"] componentsJoinedByString:@", "];
    }
    if(volumeInfo[@"description"]!=nil){
        self.bookDescription = volumeInfo[@"description"];
    }
    
    // Adding an 's' as a workaround: HTTP vs HTTPS
    if([volumeInfo valueForKeyPath:@"imageLinks.smallThumbnail"]!=nil){
        NSMutableString *imageURLString = [NSMutableString stringWithString:[volumeInfo valueForKeyPath:@"imageLinks.smallThumbnail"]];
        self.coverArtThumbnail = imageURLString;
        //[imageURLString insertString:@"s" atIndex:4];
        //self.coverArtThumbnail = [NSURL URLWithString:imageURLString];
    }
    if([volumeInfo valueForKeyPath:@"imageLinks.thumbnail"]!=nil){
        NSMutableString *imageURLString = [NSMutableString stringWithString:[volumeInfo valueForKeyPath:@"imageLinks.thumbnail"]];
        self.coverArt = imageURLString;
        //[imageURLString insertString:@"s" atIndex:4];
        //self.coverArt = [NSURL URLWithString:imageURLString];
    }
    
    if(volumeInfo[@"publishedDate"]!=nil){
        self.publishedDate = volumeInfo[@"publishedDate"];
    }
    if([volumeInfo valueForKeyPath:@"industryIdentifiers.ISBN_13"]!=nil){
        self.isbn13 = [volumeInfo valueForKeyPath:@"industryIdentifiers.ISBN_13"];
    }
    if([volumeInfo valueForKeyPath:@"industryIdentifiers.ISBN_10"]!=nil){
        self.isbn10 = [volumeInfo valueForKeyPath:@"industryIdentifiers.ISBN_10"];
    }
    if(volumeInfo[@"pageCount"]!=nil){
        self.pages = volumeInfo[@"pageCount"];
    }
    
    return self;
}

+ (NSArray *)booksWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *books = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        Book *book = [[Book alloc] initWithDictionary:dictionary];
        [books addObject:book];
    }
    return books;
}

@end
