//
//  FavoritesViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/15/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Parse/Parse.h"
#import "BookCellNib.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BookDetailsViewController.h"
#import "AddRemoveBooksHelper.h"
#import "SelectShelfViewController.h"
#import "FilterSelectionViewController.h"
#import "Filter.h"
#import "FilterDisplayCollectionCell.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterDisplayCollectionCellDelegate,FilterSelectionViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BookCellNibDelegate, SelectShelfViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *filtersCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) NSMutableArray<Book *> *favoriteBooks;
@property (strong, nonatomic) NSArray<Book *> *filteredBooks;
@property (strong, nonatomic) NSDictionary<NSNumber *, NSArray<Filter *> *> *filtersDictionary;
@property (strong, nonatomic) NSMutableArray<Filter *> *appliedFilterArray;
@end

@implementation FavoritesViewController

- (void)viewWillAppear:(BOOL)animated{
    [self reloadFavorites];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.filtersCollectionView.delegate = self;
    self.filtersCollectionView.dataSource = self;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 4;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(4, 8, 4, 8);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BookCellNib" bundle:nil] forCellReuseIdentifier:@"bookReusableCell"];
}

-(void) reloadFavorites{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *query = [relation query];
    [self queryBooksWithQuery:query];
}

-(void)queryBooksWithQuery:(PFQuery *)query{
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error getting favorites" message:@"There was an error loading your favorites" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf reloadFavorites];
            }];
            [alert addAction:retryAction];

            [strongSelf presentViewController:alert animated:YES completion:nil];
        }
        else{
            strongSelf.favoriteBooks = [books mutableCopy];
            if(strongSelf.filtersDictionary!=nil)
               [strongSelf appliedFilters:strongSelf.filtersDictionary];
            else
                strongSelf.filteredBooks = strongSelf.favoriteBooks;
            [strongSelf checkForEmptyDataSet];
            [strongSelf.tableView reloadData];
            [strongSelf.filtersCollectionView reloadData];
        }
    }];
}

-(void)checkForEmptyDataSet{
    if(self.filteredBooks.count>0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:10/255.0 green:0 blue:86/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(self.appliedFilterArray.count>0){
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:10/255.0 green:0 blue:86/255.0 alpha:1];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else{
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

#pragma mark - FilterSelectionViewControllerDelegate
-(void)appliedFilters:(NSDictionary<NSNumber *, NSArray<Filter *> *> *)appliedFilters{
    self.filtersDictionary = appliedFilters;
    if(self.appliedFilterArray == nil)
        self.appliedFilterArray = [[NSMutableArray alloc] initWithCapacity:8];
    [self.appliedFilterArray removeAllObjects];
    for(NSArray *filterArr in appliedFilters.allValues){
        for(Filter *filter in filterArr){
            if(filter.selected == YES)
               [self.appliedFilterArray addObject:filter];
        }
    }
    self.filteredBooks = [Filter appliedFilters:appliedFilters toBookArray:self.favoriteBooks];
    [self checkForEmptyDataSet];
    [self.tableView reloadData];
    [self.filtersCollectionView reloadData];
}

#pragma mark - BookCellNibDelegate
-(void)didRemove{
    [self reloadFavorites];
}
- (void)didTapMore:(Book *)book{
    [self performSegueWithIdentifier:@"selectShelfSegue" sender:book];
}
#pragma mark - SelectShelfViewControllerDelegate
- (void)didUpdateShelf{
    // No-Op
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredBooks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookCellNib *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    cell.book = self.filteredBooks[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self performSegueWithIdentifier:@"bookDetailsSegue" sender:indexPath];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        Book *bookToRemove = strongSelf.filteredBooks[indexPath.row];
        [AddRemoveBooksHelper removeFromFavorites:bookToRemove withCompletion:^(NSError * _Nullable error) {
            if(error == nil){
                [strongSelf reloadFavorites];
                completionHandler(YES);
            }
        }];
        
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = [UIColor systemRedColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.appliedFilterArray.count ==0)
        self.collectionViewHeight.constant = 0;
    else
        self.collectionViewHeight.constant = 36;
    return self.appliedFilterArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterDisplayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterDisplayCell" forIndexPath:indexPath];
    cell.filter = self.appliedFilterArray[indexPath.item];
    cell.delegate = self;
    return cell;
}
#pragma mark - FilterDisplayCollectionCellDelegate
-(void)removedFilter{
    [self reloadFavorites];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *placeholderImage =  [[UIImage systemImageNamed:@"book"] imageWithTintColor:UIColor.darkGrayColor];
    return placeholderImage;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"Mark books as favorites to see them here";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //BookCellNib *tappedCell =  sender;
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    if([segue.identifier isEqualToString:@"bookDetailsSegue"]){
        NSIndexPath *indexPath = sender;
        BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
        bookDetailsViewController.book = self.filteredBooks[indexPath.row];
    }
    else if([segue.identifier isEqualToString:@"selectShelfSegue"]){
        Book *book = sender;
        UINavigationController *navigationController = [segue destinationViewController];
        SelectShelfViewController *selectShelfViewController = (SelectShelfViewController *)[navigationController topViewController];
        selectShelfViewController.addBook = book;
        selectShelfViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"filterSelectionSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        FilterSelectionViewController *filterSelectionViewController = (FilterSelectionViewController *)[navigationController topViewController];
        filterSelectionViewController.filtersDataSource = self.filtersDictionary;
        filterSelectionViewController.delegate = self;
    }
}

@end
