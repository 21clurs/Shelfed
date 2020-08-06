//
//  ShelfViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/21/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ShelfViewController.h"
#import "BookCellNib.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AddRemoveBooksHelper.h"
#import "BookDetailsViewController.h"
#import "SelectShelfViewController.h"
#import "Filter.h"
#import "FilterSelectionViewController.h"

@interface ShelfViewController () <UITableViewDelegate, UITableViewDataSource, FilterSelectionViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BookCellNibDelegate, SelectShelfViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Book *> *booksInShelf;
@property (strong, nonatomic) NSArray<Book *> *filteredBooksInShelf;
@property (strong, nonatomic) NSDictionary<NSNumber *, NSArray<Filter *> *> *filtersDictionary;

@end

@implementation ShelfViewController

- (void)viewWillAppear:(BOOL)animated{
    [self reloadShelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BookCellNib" bundle:nil] forCellReuseIdentifier:@"bookReusableCell"];
    
    self.title = self.shelfName;
    
    [self setTapGestureRecognizers];
    [self reloadShelf];
}

-(void) reloadShelf{
    PFRelation *relation = [PFUser.currentUser relationForKey:self.shelfName];
    PFQuery *query = [relation query];
    [self queryBooksWithQueryt:query];
}

- (void) queryBooksWithQueryt:(PFQuery *)query{
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error getting shelf" message:@"There was an error loading your shelf" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf reloadShelf];
            }];
            [alert addAction:retryAction];

            [strongSelf presentViewController:alert animated:YES completion:nil];
        }
        else{
            strongSelf.booksInShelf = books;
            if(strongSelf.filtersDictionary!=nil)
               [strongSelf appliedFilters:strongSelf.filtersDictionary];
            else
                strongSelf.filteredBooksInShelf = strongSelf.booksInShelf;
            [strongSelf checkForEmptyDataSet];
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)setTapGestureRecognizers{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self.tableView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer* singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    [singleTapRecognizer setNumberOfTapsRequired:1];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.tableView addGestureRecognizer:singleTapRecognizer];
}
- (void) onDoubleTap:(UITapGestureRecognizer *)tap{
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        BookCellNib *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell didDoubleTap];
    }
}
- (void) onSingleTap:(UITapGestureRecognizer *)tap{
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        [self performSegueWithIdentifier:@"bookDetailsSegue" sender:indexPath];
    }
}

-(void)checkForEmptyDataSet{
    if(self.filteredBooksInShelf.count>0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:10/255.0 green:0 blue:86/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - FilterSelectionViewControllerDelegate
-(void)appliedFilters:(NSDictionary<NSNumber *, NSArray<Filter *> *> *)appliedFilters{
    self.filtersDictionary = appliedFilters;
    self.filteredBooksInShelf = [Filter appliedFilters:appliedFilters toBookArray:self.booksInShelf];
    [self.tableView reloadData];
}

#pragma mark - BookCellNibDelegate
- (void)didRemove{
    // No-op
}
- (void)didTapMore:(Book *)book{
    [self performSegueWithIdentifier:@"selectShelfSegue" sender:book];
}

#pragma mark - SelectShelfViewControllerDelegate
- (void)didUpdateShelf{
    [self reloadShelf];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredBooksInShelf.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCellNib *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    cell.book = self.filteredBooksInShelf[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //[self performSegueWithIdentifier:@"bookDetailsSegue" sender:indexPath];
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        Book *bookToRemove = strongSelf.filteredBooksInShelf[indexPath.row];
        [AddRemoveBooksHelper removeBook:bookToRemove fromArray:strongSelf.shelfName withCompletion:^(NSError * _Nonnull error) {
            [strongSelf reloadShelf];
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
    NSString *text = @"Add books to this shelf to see them here";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"bookDetailsSegue"]){
        NSIndexPath *indexPath = sender;
        BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
        bookDetailsViewController.book = self.filteredBooksInShelf[indexPath.row];
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
