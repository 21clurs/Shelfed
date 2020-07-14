//
//  GoodreadsAPI.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "GoodreadsAPIManager.h"

static NSString * const baseURLString = @"https://www.goodreads.com/";
static NSString * const consumerKey = @"ZNPPhZqsXiqSE5QWfibSdw";
static NSString * const consumerSecret = @"Qapupi0t4II02jo1WOUX8HdOb8ddAburQquCQYxeyIE";

@implementation GoodreadsAPIManager

-(id)init{
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}
-(void)defaultHomeQuery: (void(^)(NSArray *works, NSError *error))completion{
    NSString *defaultSearchString = @"the";
    NSString *queryString = [NSString stringWithFormat:@"%@%@?key=%@&q=%@", baseURLString, @"search/index.xml", consumerKey, defaultSearchString];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0 ];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);

            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            completion(nil, error);
        }
        else {
            
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            if([self.xmlParser parse]){
                  NSLog(@"%@",self.results);
            }
            //NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(self.results, nil);

            // The network request has completed, and succeeded.
            // Invoke the completion block with the movies array.
            // Think of invoking a block like calling a function with parameters
        }
    }];
    [task resume];
}
-(void)searchWithQuery: (NSString *)search andCompletion: (void(^)(NSArray *works, NSError *error))completion{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    if([elementName isEqualToString:@"results"]){
        self.results=[[NSMutableArray alloc] init];
    }
    else{
        if([elementName isEqualToString:@"work"]){
            self.bookDict=[[NSMutableDictionary alloc] init];
        }
        self.value = nil;
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if(!self.value){
        self.value = [[NSMutableString alloc] init];
    }
    [self.value appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    /*if(self.parsedString){
        [self.parsedString appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if([elementName isEqualToString:@"work"]){
        [self.results addObject:self.bookDict];
        self.bookDict = nil;
    }
    else if([elementName isEqualToString:@"title"]){
        [self.bookDict setValue:self.value forKey:elementName];
    }
    else if([elementName isEqualToString:@"name"]){
        [self.bookDict setValue:self.value forKey:elementName];
    }
}

@end
