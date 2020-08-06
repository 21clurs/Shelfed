//
//  FilterDisplayContainerViewController.h
//  Shelfed
//
//  Created by Clara Kim on 8/6/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"
#import "FilterDisplayCollectionCell.h"
NS_ASSUME_NONNULL_BEGIN
@protocol FilterDisplayContainerViewControllerDelegate <NSObject>
-(void)didRemoveFilter;
-(void)noFiltersApplied;
-(void)filtersApplied;
@end

@interface FilterDisplayContainerViewController : UIViewController
@property (weak, nonatomic) id<FilterDisplayContainerViewControllerDelegate>delegate;
@property (strong,nonatomic) NSDictionary<NSNumber *, NSArray<Filter  *> *> *filtersDictionary;
@end

NS_ASSUME_NONNULL_END
