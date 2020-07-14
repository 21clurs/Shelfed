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
-(id)init{
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

-(void)defaultHomeQuery: (void(^)(NSArray *books, NSError *error))completion{
    NSString *defaultSearchString = @"the";
    
    //things to think about: &projection=lite
    NSString *queryString = [NSString stringWithFormat:@"%@volumes?q=%@&maxResults=20&key=%@", baseURLString, defaultSearchString, apiKey];
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
            //NSLog(@"%@",items);
            completion(booksArray,nil);
        }
    }];
    [task resume];
}

-(void)searchBooks: (NSString *)searchString andCompletion:(void(^)(NSArray *books, NSError *error))completion{
    
    NSString *queryString = [NSString stringWithFormat:@"%@volumes?q=%@&maxResults=20&key=%@", baseURLString, searchString, apiKey];
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
