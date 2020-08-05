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
@dynamic associatedBookID;

+ (nonnull NSString *)parseClassName {
    return @"Upload";
}

- (id)initWithImageFile:(NSData *)imageData andBook:(Book *)book{
    self = [super init];
    
    self.uploadImageFile = [PFFileObject fileObjectWithName:@"upload_image.png" data:imageData];
    self.associatedBookID = book.bookID;
    return self;
}

-(void)saveUploadToParseWithCompletion: (void(^)(NSError *error))completion{
    __weak typeof(self) weakSelf = self;
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            NSLog(@"Error saving upload to Parse");
            completion(error);
        }
        else{
            PFRelation *relation = [PFUser.currentUser relationForKey:@"userUploads"];
            [relation addObject:strongSelf];
            [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error!=nil)
                    completion(error);
                else
                    completion(nil);
            }];
        }
    }];
}

@end
