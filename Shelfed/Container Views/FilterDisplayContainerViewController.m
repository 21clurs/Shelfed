//
//  FilterDisplayContainerViewController.m
//  Shelfed
//
//  Created by Clara Kim on 8/6/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterDisplayContainerViewController.h"

@interface FilterDisplayContainerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterDisplayCollectionCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSMutableArray<Filter *> *appliedFiltersArray;

@end

@implementation FilterDisplayContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 4;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(4, 8, 4, 8);
}
- (void)setFiltersDictionary:(NSDictionary<NSNumber *,NSArray<Filter *> *> *)filtersDictionary{
    _filtersDictionary = filtersDictionary;
    [self makeFiltersArrayFromDict];
}

- (void)makeFiltersArrayFromDict{
    if(self.appliedFiltersArray == nil)
        self.appliedFiltersArray = [[NSMutableArray alloc] initWithCapacity:8];
    [self.appliedFiltersArray removeAllObjects];
    for(NSArray *filterArr in self.filtersDictionary.allValues){
        for(Filter *filter in filterArr){
            if(filter.selected == YES)
               [self.appliedFiltersArray addObject:filter];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.appliedFiltersArray.count ==0)
        [self.delegate noFiltersApplied];
    else
        [self.delegate filtersApplied];
    
     return self.appliedFiltersArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterDisplayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterDisplayCell" forIndexPath:indexPath];
    cell.filter = self.appliedFiltersArray[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark - FilterDisplayCollectionCellDelegate
-(void)removedFilter{
    [self makeFiltersArrayFromDict];
    [self.delegate didRemoveFilter];
    //[self reloadFavorites];
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
