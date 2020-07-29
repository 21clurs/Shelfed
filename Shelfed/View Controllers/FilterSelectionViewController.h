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
-(void)applyFilters:(NSDictionary *)pagesPublishValuesDict withSelected:(NSDictionary *)pagesPublishSelectedDict andGenres:(NSArray *) genresArray;
@end

@interface FilterSelectionViewController : UIViewController
@property (weak,nonatomic)id<FilterSelectionViewControllerDelegate> delegate;
@property (strong, nonatomic)NSMutableDictionary<NSString *, NSNumber *> *pagesPublishSelectedDict;
@property (strong, nonatomic)NSMutableDictionary<NSString *, NSNumber *> *pagesPublishValuesDict;
@property (strong, nonatomic)NSMutableArray<NSString *> *genresSelectedArray;
@end

NS_ASSUME_NONNULL_END
