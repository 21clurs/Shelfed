//
//  SelectShelfViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/22/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectShelfViewControllerDelegate <NSObject>
- (void)didUpdateShelf;
@end

@interface SelectShelfViewController : UIViewController

@property(weak,nonatomic)id<SelectShelfViewControllerDelegate>delegate;
@property(strong,nonatomic) Book * addBook;

@end

NS_ASSUME_NONNULL_END
