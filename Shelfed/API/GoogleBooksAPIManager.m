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
NSInteger loadBy = 20;

-(id)init{
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

-(void)searchBooks: (NSString *)searchString andCompletion:(void(^)(NSArray *books, NSError *error))completion{
    NSString *searchableString = [self makeSearchable:searchString];
    
    if([searchableString isEqualToString:@""]){
        currentSearchString = @"the";
    }
    else{
        currentSearchString = searchableString;
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
    currentSearchIndex += loadBy;
    [self loadHelper:completion];
}

-(void)loadHelper: (void(^)(NSArray *books, NSError *error))completion{
    NSString *queryString = [NSString stringWithFormat:@"%@volumes?q=%@&maxResults=%ld&startIndex=%ld&key=%@", baseURLString, currentSearchString, loadBy, currentSearchIndex, apiKey];
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

-(void)getBookWithBookID: (NSString *)bookID andCompletion: (void(^)(NSDictionary *bookDict, NSError *error))completion{
    NSString *queryString = [NSString stringWithFormat:@"%@volumes/%@", baseURLString, bookID];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

-(void)getBooksForAuthors: (NSString *)authorsString andCompletion: (void(^)(NSArray *books, NSError *error))completion{
    NSString *authorsSearchableString = [self makeSearchable:authorsString];
    
    NSString *queryString = [NSString stringWithFormat:@"%@volumes?q=inauthor:%@&maxResults=%ld&startIndex=%ld&key=%@", baseURLString, authorsSearchableString, loadBy, currentSearchIndex, apiKey];
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

-(NSString *)makeSearchable:(NSString *)string{
    NSString *searchableString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
    searchableString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@"+"];
    return searchableString;
}

@end
