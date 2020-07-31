//
//  Filter.h
//  Shelfed
//
//  Created by Clara Kim on 7/30/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Filter : NSObject

@property (strong, nonatomic) NSString *filterTypeString;
@property (nonatomic) bool selected;

@property (nonatomic) bool lessThanBool;
@property (nonatomic) bool beforeBool;

@property (strong, nonatomic) NSString *genre;
@property (nonatomic) int pages;
@property (nonatomic) int year;

-(Filter *)initLengthFilterWithPages: (NSString *)pages andLessThan:(bool)lessThanBool;
-(Filter *)initYearFilterWithYear: (NSString *)year andBefore:(bool)beforeBool;
-(Filter *)initGenreFilterWithGenre:(NSString *)genre;

+(NSArray *)appliedFilters: (NSDictionary<NSNumber *, NSArray<Filter *> *> *)appliedFilters toBookArray: (NSArray *)bookArray;

@end

NS_ASSUME_NONNULL_END
