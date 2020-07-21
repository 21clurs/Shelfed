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
+(void)toggleFavorites:(NSString *)bookID{
    
}

+(void)addToFavorites: (Book *)book withCompletion:(void(^)(NSError *error))completion{
    [self addBook:book toArray:@"favoritesArray" withCompletion:completion];
}

+(void)removeFromFavorites: (Book *)book withCompletion:(void(^)(NSError *error))completion{
    [self removeBook:book fromArray:@"favoritesArray" withCompletion:completion];
}

+(void)addBook: (Book *)book toArray:(NSString *)arrayName withCompletion:(void(^)(NSError *error))completion{
    [self addToParse:book];
    NSMutableArray *temp = PFUser.currentUser[arrayName];
    [temp addObject:book.bookID];
    PFUser.currentUser[arrayName] = temp;
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"Error adding book to array");
            completion(error);
        }
        else{
            completion(nil);
        }
    }];
}

+(void)removeBook: (Book *)book fromArray:(NSString *)arrayName withCompletion:(void(^)(NSError *error))completion{
    NSMutableArray *temp = PFUser.currentUser[arrayName];
    [temp removeObject:book.bookID];
    PFUser.currentUser[@"favoritesArray"] = temp;
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"Error removing from user favorites");
            completion(error);
        }
        else{
            completion(nil);
        }
    }];
}

+(void)addToParse:(Book *)addBook{
    NSMutableArray *bookIDs = [[NSMutableArray alloc] init];
    
    PFQuery *booksQuery = [PFQuery queryWithClassName:@"Book"];
    [booksQuery selectKeys: @[@"bookID"]];
    
    [booksQuery findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        if (books) {
            for (Book * book in books){
                [bookIDs addObject:book.bookID];
            }
            if(![bookIDs containsObject:addBook.bookID]){
                [addBook saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error!=nil){
                    NSLog(@"Error saving book to Parse");
                }
                }];
            }
        }
        else {
            NSLog(@"Error getting books");
        }
    }];
    
}

@end