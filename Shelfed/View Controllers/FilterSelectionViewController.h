//
//  FilterSelectionViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/27/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FilterSelectionViewControllerDelegate <NSObject>
-(void)applyFilters:(NSArray<Filter *> *)filtersArray;

@end

@interface FilterSelectionViewController : UIViewController
@property (weak,nonatomic)id<FilterSelectionViewControllerDelegate> delegate;
@property (strong,nonatomic) NSMutableArray<Filter *> *filtersArray;
@end

NS_ASSUME_NONNULL_END
