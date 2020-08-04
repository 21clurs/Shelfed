//
//  NSString+NSStringStripHTML.m
//  Shelfed
//
//  Created by Clara Kim on 8/4/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "NSString+NSStringStripHTML.h"

@implementation NSString(NSString_NSStringStripHTML)
-(NSString *) stringByStrippingHTML{
    NSRange r;
    NSString *string = [self copy];
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    string = [string stringByReplacingCharactersInRange:r withString:@""];
    return string;
    // https://stackoverflow.com/questions/277055/remove-html-tags-from-an-nsstring-on-the-iphone
}
@end
