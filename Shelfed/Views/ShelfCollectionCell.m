//
//  ShelfCollectionCell.m
//  Shelfed
//
//  Created by Clara Kim on 7/21/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ShelfCollectionCell.h"

@implementation ShelfCollectionCell

-(void)setShelfName:(NSString *)shelfName{
    _shelfName = shelfName;
    
    self.shelfNameLabel.text = shelfName;
    
    if([shelfName isEqualToString:@"Read"]){
        [self.shelfPicView setImage:[UIImage imageNamed:@"BookShelf1"]];
    }
    else if([shelfName isEqualToString:@"Reading"]){
        [self.shelfPicView setImage:[UIImage imageNamed:@"BookShelf2"]];
    }
}

@end
