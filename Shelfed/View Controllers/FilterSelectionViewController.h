//
//  FilterSelectionViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/27/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

typedef NS_ENUM(NSUInteger, FilterSectionType) {
  FilterSectionTypePages,
  FilterSectionTypeYear,
  FilterSectionTypeGenre,
};

NS_ASSUME_NONNULL_BEGIN
@protocol FilterSelectionViewControllerDelegate <NSObject>
-(void)appliedFilters:(NSDictionary<NSNumber *, NSArray<Filter *> *> *)appliedFilters;
@end

@interface FilterSelectionViewController : UIViewController
@property (weak,nonatomic)id<FilterSelectionViewControllerDelegate> delegate;
@property (strong,nonatomic) NSDictionary<NSNumber *, NSArray<Filter *> *> *filtersDataSource;

@end

NS_ASSUME_NONNULL_END
