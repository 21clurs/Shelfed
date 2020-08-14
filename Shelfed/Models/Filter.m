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

+(NSArray *)appliedFilters: (NSDictionary<NSNumber *, NSArray<Filter *> *> *)appliedFilters toBookArray: (NSArray *)bookArray{
    
    NSArray *temp = bookArray;
    NSMutableArray *genreArray = [[NSMutableArray alloc] init];
    
    for(NSNumber *key in appliedFilters.allKeys){
        for(Filter *filter in [appliedFilters objectForKey:key]){
            if(filter.selected == NO)
                continue;
            if(filter.genre != nil){
                [genreArray addObject:filter.genre];
                continue;
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
    }

    NSPredicate *genrePredicate;
    NSMutableSet *categoriesFromGenresSet = [[NSMutableSet alloc] init];
    bool othersSelected = NO;
    if(genreArray.count > 0){
        for(NSString *genre in genreArray){
            if([genre isEqualToString:@"Other"]){
                othersSelected = YES;
            }
            else{
                [categoriesFromGenresSet addObject:genre];
                if([genre isEqualToString:@"Nonfiction"]){
                    [categoriesFromGenresSet addObjectsFromArray:[[NSArray alloc] initWithObjects:@"Art",@"Science",@"History",@"Music",@"Computers",@"English",@"Social Science",@"Biography & Autobiography",@"Literary Criticism",nil]];
                }
            }
        }
        NSSet *othersHelperSet = [[NSSet alloc] initWithArray:[[NSArray alloc] initWithObjects:@"Fiction",@"Nonfiction",@"Juvenile Fiction",@"Art",@"Science",@"History",@"Music",@"Computers",@"English",@"Social Science",@"Biography & Autobiography",@"Literary Criticism",nil]];
        genrePredicate = [NSPredicate predicateWithBlock:^BOOL(Book *evaluatedBook, NSDictionary *bindings) {
               if(othersSelected == YES){
                   for(NSString *category in evaluatedBook.categories){
                       if(![othersHelperSet containsObject:category])
                           return true;
                   }
               }
               for(NSString *category in evaluatedBook.categories){
                   if([categoriesFromGenresSet containsObject:category])
                       return true;
               }
               return false;
           }];
    }
    if(genrePredicate!=nil)
        temp = [[temp filteredArrayUsingPredicate:genrePredicate] mutableCopy];
    return temp;
}


@end
