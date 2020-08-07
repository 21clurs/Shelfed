//
//  AddRemoveBooksHelper.m
//  Shelfed
//
//  Created by Clara Kim on 7/20/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "AddRemoveBooksHelper.h"
#import "Parse/Parse.h"


@implementation AddRemoveBooksHelper

+ (void)getBookForID: (NSString *)bookID withCompletion:(void(^)(Book *book, NSError * _Nullable error)) completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
    [query whereKey:@"bookID" equalTo:bookID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            Book *book = objects[0];
            completion(book, nil);
        } else {
            NSLog(@"Could not find book in Book...");
            completion(nil,error);
        }
    }];
}

+(void)addToFavorites: (Book *)book withCompletion:(void(^)(NSError *error))completion{
    [self addBook:book toArray:@"favorites" withCompletion:completion];
}

+(void)removeFromFavorites: (Book *)book withCompletion:(void(^)(NSError *error))completion{
    [self removeBook:book fromArray:@"favorites" withCompletion:completion];
}

+(void)addBook: (Book *)book toArray:(NSString *)arrayName withCompletion:(void(^)(NSError *error))completion{
    
    [self addToParse:book withCompletion:^(Book * _Nullable bookToAdd, NSError * _Nullable error) {

        [self removeDuplicates:arrayName ofBook:bookToAdd];
        
        PFRelation *relation = [PFUser.currentUser relationForKey:arrayName];
        if(bookToAdd !=nil){
            [relation addObject:bookToAdd];
        }
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded==YES)
                completion(nil);
        }];
    }];
}

+(void)removeBook: (Book *)book fromArray:(NSString *)arrayName withCompletion:(void(^)(NSError *error))completion{
    if(PFUser.currentUser[arrayName]!=nil){
        PFQuery *booksQuery = [PFQuery queryWithClassName:@"Book"];
        [booksQuery whereKey:@"bookID" equalTo:book.bookID];
        
        [booksQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable bookToRemove, NSError * _Nullable error) {
            if(bookToRemove != nil){
                PFRelation *relation = [PFUser.currentUser relationForKey:arrayName];
                [relation removeObject:bookToRemove];
                [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded == YES)
                        completion(nil);
                } ];
            }
        }];
    }
}

+(void)removeDuplicates:(NSString *)arrayName ofBook:(Book *)book{
    if([arrayName isEqualToString:@"Read"]){
        // Remove from "Reading"
        [self removeBook:book fromArray:@"Reading" withCompletion:^(NSError * _Nonnull error) {}];
    }
    else if([arrayName isEqualToString:@"Reading"]){
        // Remove from "Read"
        [self removeBook:book fromArray:@"Read" withCompletion:^(NSError * _Nonnull error) {}];
    }
}

+(void)addToParse:(Book *)addBook withCompletion:(void(^)(Book * _Nullable bookToAdd, NSError * _Nullable error))completion{
    
    PFQuery *booksQuery = [PFQuery queryWithClassName:@"Book"];
    [booksQuery selectKeys: @[@"bookID"]];
    
    [booksQuery findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        
        Book *bookToAdd;
        if (books) {
            for (Book * book in books){
                if([book.bookID isEqualToString:addBook.bookID]){
                    bookToAdd = book;
                    break;
                }
            }
            if(bookToAdd == nil){
                bookToAdd = addBook;
                [addBook saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error!=nil){
                    NSLog(@"Error saving book to Parse");
                }
                else{
                    completion(bookToAdd,nil);
                }
                }];
            }
            else {
                // Book is already in Parse
                completion(bookToAdd, nil);
            }
        }
        else {
            NSLog(@"Error getting books");
        }
    }];
    
}

@end
