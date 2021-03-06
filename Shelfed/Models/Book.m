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
@dynamic authorsString;
@dynamic bookID;

@dynamic coverArtThumbnail;

@dynamic publishedDate;
//@dynamic printType;
@dynamic categories;
@dynamic pages;


+ (nonnull NSString *)parseClassName {
    return @"Book";
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    self.bookID = dictionary[@"id"];
    
    NSDictionary *volumeInfo = dictionary[@"volumeInfo"];
    self.title = volumeInfo[@"title"];
    /*
    if(volumeInfo[@"subtitle"]!=nil){
        self.subtitle = volumeInfo[@"subtitle"];
    }
    */
    if(volumeInfo[@"authors"]!=nil){
        //self.authorsArray = volumeInfo[@"authors"];
        self.authorsString = [volumeInfo[@"authors"] componentsJoinedByString:@", "];
    }
    else{
        self.authorsString = @"Unknown Author";
    }
    /*
    if(volumeInfo[@"description"]!=nil){
        self.bookDescription = volumeInfo[@"description"];
    }
    */
    // Adding an 's' as a workaround: HTTP vs HTTPS
    if([volumeInfo valueForKeyPath:@"imageLinks.smallThumbnail"]!=nil){
        NSMutableString *imageURLString = [NSMutableString stringWithString:[volumeInfo valueForKeyPath:@"imageLinks.smallThumbnail"]];
        self.coverArtThumbnail = imageURLString;
        //[imageURLString insertString:@"s" atIndex:4];
        //self.coverArtThumbnail = [NSURL URLWithString:imageURLString];
    }
    /*
    if([volumeInfo valueForKeyPath:@"imageLinks.thumbnail"]!=nil){
        NSMutableString *imageURLString = [NSMutableString stringWithString:[volumeInfo valueForKeyPath:@"imageLinks.thumbnail"]];
        self.coverArt = imageURLString;
        //[imageURLString insertString:@"s" atIndex:4];
        //self.coverArt = [NSURL URLWithString:imageURLString];
    }
    */
    if(volumeInfo[@"publishedDate"]!=nil){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if([volumeInfo[@"publishedDate"] length] == 10)
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        else if([volumeInfo[@"publishedDate"] length] == 7)
            [dateFormatter setDateFormat:@"yyyy-MM"];
        else if([volumeInfo[@"publishedDate"] length] == 4)
            [dateFormatter setDateFormat:@"yyyy"];
        NSDate *date = [dateFormatter dateFromString:volumeInfo[@"publishedDate"]];
        self.publishedDate = date;
    }
    /*
    if(volumeInfo[@"printType"]!=nil){
        self.printType = volumeInfo[@"printType"];
    }
    */
    if(volumeInfo[@"categories"]!=nil){
        self.categories = volumeInfo[@"categories"];
    }
    /*
    for(NSDictionary *dict in volumeInfo[@"industryIdentifiers"]){
        if([dict[@"type"] isEqualToString:@"ISBN_13"])
            self.isbn13 = dict[@"identifier"];
    }
    */
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
