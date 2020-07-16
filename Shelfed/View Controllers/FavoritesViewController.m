//
//  FavoritesViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/15/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Parse/Parse.h"
#import "BookCell.h"
//#import "EmptyTableView.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Book *> *favorites;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if(PFUser.currentUser[@"favoritesArray"]!=nil){
        self.favorites = PFUser.currentUser[@"favoritesArray"];
    }
    else{
        self.favorites = [[NSArray alloc] init];
        PFUser.currentUser[@"favoritesArray"] = self.favorites;
        [PFUser.currentUser saveInBackground];
 //       self.tableView.backgroundView = [[EmptyTableView alloc] init];
    }
    
    if(self.favorites.count==0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favorites.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
