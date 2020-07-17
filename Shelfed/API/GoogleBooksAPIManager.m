//
//  GoogleBooksAPIManager.m
//  Shelfed
//
//  Created by Clara Kim on 7/14/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "GoogleBooksAPIManager.h"
#import "Book.h"

static NSString *const baseURLString = @"https://www.googleapis.com/books/v1/";
static NSString *const apiKey = @"AIzaSyCrGgWjsndS7vfcYaC-CpyqlktNDSnVnzE";

@implementation GoogleBooksAPIManager

NSString *currentSearchString;
NSInteger currentSearchIndex;

-(id)init{
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

-(void)searchBooks: (NSString *)searchString andCompletion:(void(^)(NSArray *books, NSError *error))completion{
    if([searchString isEqualToString:@""]){
        currentSearchString = @"the";
    }
    else{
        currentSearchString = searchString;
    }
    currentSearchIndex = 0;
    [self loadHelper:completion];
}

-(void)reloadBooks:(void(^)(NSArray *books, NSError *error))completion{
    if(currentSearchString==nil || [currentSearchString isEqualToString:@""]){
        currentSearchString = @"the";
    }
    currentSearchIndex=0;
    [self loadHelper:completion];
}

-(void)loadMoreBooks: (void(^)(NSArray *books, NSError *error))completion{
    currentSearchIndex += 20;
    [self loadHelper:completion];
}

-(void)loadHelper: (void(^)(NSArray *books, NSError *error))completion{
    
    NSString *queryString = [NSString stringWithFormat:@"%@volumes?q=%@&maxResults=20&startIndex=%ld&key=%@", baseURLString, currentSearchString, currentSearchIndex, apiKey];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *items = dataDictionary[@"items"];
            NSArray *booksArray = [Book booksWithDictionaries:items];
            completion(booksArray,nil);
        }
    }];
    [task resume];
}

@end
