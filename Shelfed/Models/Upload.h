//
//  Upload.h
//  Shelfed
//
//  Created by Clara Kim on 7/24/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import <Parse/Parse.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Upload : PFObject<PFSubclassing>

@property (strong, nonatomic)PFFileObject *uploadImageFile;
@property (strong, nonatomic)Book *associatedBook;

@end

NS_ASSUME_NONNULL_END
