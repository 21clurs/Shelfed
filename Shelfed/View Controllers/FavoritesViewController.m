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

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, FilterSelectionViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BookCellNibDelegate, SelectShelfViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Book *> *favoriteBooks;
@property (strong, nonatomic) NSArray<Book *> *filteredBooks;
@property (strong, nonatomic) NSArray<Filter *> *filtersArray;
@property (strong, nonatomic) NSDictionary<NSNumber *, NSArray<Filter *> *> *filtersDictionary;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BookCellNib" bundle:nil] forCellReuseIdentifier:@"bookReusableCell"];
}

-(void) reloadFavorites{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *query = [relation query];
    [self queryBooksWithQuery:query];
}

-(void)queryBooksWithQuery:(PFQuery *)query{
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        if(error!=nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error getting favorites" message:@"There was an error loading your favorites" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self reloadFavorites];
            }];
            [alert addAction:retryAction];

            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            self.favoriteBooks = [books mutableCopy];
            self.filteredBooks = self.favoriteBooks;
            if(self.favoriteBooks.count>0){
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - FilterSelectionViewControllerDelegate
-(void)appliedFilters:(NSDictionary<NSNumber *, NSArray<Filter *> *> *)appliedFilters{
    self.filtersDictionary = appliedFilters;
    self.filteredBooks = [Filter appliedFilters:appliedFilters toBookArray:self.favoriteBooks];
    [self.tableView reloadData];
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
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        Book *bookToRemove = self.filteredBooks[indexPath.row];
        [AddRemoveBooksHelper removeFromFavorites:bookToRemove withCompletion:^(NSError * _Nonnull error) {
            [self reloadFavorites];
            completionHandler(YES);
        }];
        
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = [UIColor systemRedColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
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
