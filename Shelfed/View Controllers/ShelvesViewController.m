//
//  ShelvesViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/16/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ShelvesViewController.h"
#import "Parse/Parse.h"
#import "ShelfCell.h"
#import "ShelfCollectionCell.h"

@interface ShelvesViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *shelvesArray;

@end

@implementation ShelvesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    if(PFUser.currentUser[@"userShelves"]!=nil){
        self.shelvesArray = PFUser.currentUser[@"userShelves"];
    }
    else{
        self.shelvesArray = [[NSMutableArray alloc] init];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger shelvesCount = 0;
    if(PFUser.currentUser[@"userShelves"]!=nil){
        shelvesCount = ((NSMutableArray *)PFUser.currentUser[@"userShelves"]).count;
    }
    return shelvesCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShelfCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShelfCollectionCell" forIndexPath:indexPath];
    cell.shelfName = self.shelvesArray[indexPath.row];
    return cell;
}

/*
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger shelvesCount = 0;
    if(PFUser.currentUser[@"userShelves"]!=nil){
        shelvesCount = ((NSMutableArray *)PFUser.currentUser[@"userShelves"]).count;
    }
    return shelvesCount;
//    return PFUser.currentUser[@"userShelves"].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShelfCell"];
    cell.shelfName = self.shelvesArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
