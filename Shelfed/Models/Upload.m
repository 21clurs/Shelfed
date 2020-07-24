//
//  Upload.m
//  Shelfed
//
//  Created by Clara Kim on 7/24/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "Upload.h"

@implementation Upload

@dynamic uploadImageFile;
@dynamic associatedBook;

+ (nonnull NSString *)parseClassName {
    return @"Upload";
}

- (id)initWithImageFile:(PFFileObject *)file andBook:(Book *)book{
    self = [super init];
    self.uploadImageFile = file;
    self.associatedBook = book;
    return self;
}

@end
