//
//  BookDetailsViewController.h
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
//#import <FaveButton/FaveButton-Swift.h>
//#import <FaveButton-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailsViewController : UIViewController

@property (strong,nonatomic) Book *book;

@end

NS_ASSUME_NONNULL_END
