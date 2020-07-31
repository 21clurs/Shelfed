//
//  FilterSelectionViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/27/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FilterSelectionViewControllerDelegate <NSObject>
-(void)applyFilters:(NSArray *)filtersArray;

@end

@interface FilterSelectionViewController : UIViewController
@property (weak,nonatomic)id<FilterSelectionViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
