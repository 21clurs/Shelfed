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
#import "ShelfViewController.h"

@interface ShelvesViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSMutableArray<NSString *> *shelvesArray;

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
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 8;
    self.flowLayout.minimumInteritemSpacing = 8;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int numberOfCellsPerRow = 2;
    CGFloat cellWidth = (self.collectionView.frame.size.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - self.flowLayout.minimumInteritemSpacing*(numberOfCellsPerRow-1))/numberOfCellsPerRow;
    CGFloat cellHeight = 1.4*cellWidth;
    return CGSizeMake(cellWidth, cellHeight);

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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShelfCollectionCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSString *shelf = self.shelvesArray[indexPath.item];
    
    ShelfViewController *shelfViewController = [segue destinationViewController];
    shelfViewController.shelfName = shelf;
}


@end
