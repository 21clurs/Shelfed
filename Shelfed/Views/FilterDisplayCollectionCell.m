//
//  FilterDisplayCollectionCell.m
//  Shelfed
//
//  Created by Clara Kim on 8/6/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterDisplayCollectionCell.h"

@implementation FilterDisplayCollectionCell
- (IBAction)didTapRemoveFilter:(id)sender {
    self.filter.selected = NO;
    [self.delegate removedFilter];
}

- (void)setFilter:(Filter *)filter{
    _filter = filter;
    if(filter.genre!=nil){
        if([filter.genre isEqualToString:@"Juvenile Fiction"])
            self.filterNameLabel.text = [NSString stringWithFormat:@"Young Adult"];
        else
            self.filterNameLabel.text = [NSString stringWithFormat:@"%@",filter.genre];
    }
    else if([filter.filterTypeString isEqualToString:@"PagesLess"]){
        self.filterNameLabel.text = [NSString stringWithFormat:@"Pages < %d", filter.pages];
    }
    else if([filter.filterTypeString isEqualToString:@"PagesGreater"]){
        self.filterNameLabel.text = [NSString stringWithFormat:@"Pages > %d", filter.pages];
    }
    else if([filter.filterTypeString isEqualToString:@"PublishedBefore"]){
        self.filterNameLabel.text = [NSString stringWithFormat:@"Before %d", filter.year];
    }
    else if([filter.filterTypeString isEqualToString:@"PublishedAfter"]){
        self.filterNameLabel.text = [NSString stringWithFormat:@"After %d", filter.year];
    }
}

@end
