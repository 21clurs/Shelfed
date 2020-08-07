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

+ (void)saveUploadToParse:(Upload *)upload WithCompletion: (void(^)(NSError *error))completion{
    [upload saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"Error saving upload to Parse");
            completion(error);
        }
        else{
            PFRelation *relation = [PFUser.currentUser relationForKey:@"userUploads"];
            [relation addObject:upload];
            
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
