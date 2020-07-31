//
//  Filter.m
//  Shelfed
//
//  Created by Clara Kim on 7/30/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "Filter.h"
#import "Book.h"

@implementation Filter

-(Filter *)initLengthFilterWithPages: (NSString *)pages andLessThan:(bool)lessThanBool{
    self = [super init];
    if(lessThanBool == YES){
        self.filterTypeString = @"PagesLess";
    }
    else{
        self.filterTypeString = @"PagesGreater";
    }
    self.pages = [pages intValue];
    self.lessThanBool = lessThanBool;
    return self;
}
-(Filter *)initYearFilterWithYear: (NSString *)year andBefore:(bool)beforeBool{
    self = [super init];
    if(beforeBool == YES){
        self.filterTypeString = @"PublishedBefore";
    }
    else{
        self.filterTypeString = @"PublishedAfter";
    }
    self.year = [year intValue];
    self.beforeBool = beforeBool;
    return self;
}
-(Filter *)initGenreFilterWithGenre:(NSString *)genre{
    self.filterTypeString = @"Genre";
    self.genre = genre;
    return self;
}

+(NSArray *)applyFilters: (NSArray<Filter *> *)filtersArray toBookArray: (NSArray<Book  *> *)bookArray{
    NSArray *temp = bookArray;
    NSMutableArray *genreArray = [[NSMutableArray alloc] init];
    for(Filter *filter in filtersArray){
        if(filter.genre != nil){
            [genreArray addObject:filter.genre];
            break;
        }
        
        NSPredicate *predicate;
        if([filter.filterTypeString isEqualToString:@"PagesLess"] || [filter.filterTypeString isEqualToString:@"PagesGreater"]){
            predicate = [NSPredicate predicateWithBlock:^BOOL(Book *evaluatedBook, NSDictionary *bindings) {
                bool isLessThan = ([evaluatedBook.pages intValue] <= filter.pages);
                return (isLessThan == filter.lessThanBool);
            }];
        }
        else if([filter.filterTypeString isEqualToString:@"PublishedBefore"] || [filter.filterTypeString isEqualToString:@"PublishedAfter"]){
            predicate = [NSPredicate predicateWithBlock:^BOOL(Book *evaluatedBook, NSDictionary *bindings) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy"];
                NSString* myMonthString = [dateFormatter stringFromDate:evaluatedBook.publishedDate];
                bool isBefore = ([myMonthString intValue] <= filter.year);
                return (isBefore == filter.beforeBool);
            }];
        }
        
        if(predicate !=nil)
            temp = [temp filteredArrayUsingPredicate:predicate];
    }
    
    for(NSString *genre in genreArray){
        NSPredicate *predicate;
        if([genre isEqualToString:@"Other"]){
            NSArray *otherHelperArr = [[NSArray alloc] initWithObjects:@"Fiction",@"Nonfiction",@"Juvenile Fiction",@"Art",@"Science",@"History",@"Music",@"Computers",@"English",@"Social Science",nil];
            predicate = [NSPredicate predicateWithBlock:^BOOL(Book *evaluatedBook, NSDictionary *bindings) {
                for(NSString *category in evaluatedBook.categories){
                    if([otherHelperArr containsObject:category])
                        return false;
                }
                return true;
            }];
        }
        else{
            predicate = [NSPredicate predicateWithBlock:^BOOL(Book *evaluatedBook, NSDictionary *bindings) {
                return ([evaluatedBook.categories containsObject:genre]);
            }];
        }
        if([genre isEqualToString:@"Nonfiction"]){
            NSArray *nonfictionHelperArr = [[NSArray alloc] initWithObjects:@"Art",@"Science",@"History",@"Music",@"Computers",@"English",@"Social Science",nil];
            predicate = [NSPredicate predicateWithBlock:^BOOL(Book *evaluatedBook, NSDictionary *bindings) {
                for(NSString *category in evaluatedBook.categories){
                    if([nonfictionHelperArr containsObject:category])
                        return true;
                }
                return false;
            }];
        }
        if(predicate!=nil)
            temp = [[temp filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    return temp;
}


@end
