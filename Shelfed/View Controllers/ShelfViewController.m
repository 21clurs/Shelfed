//
//  ShelfViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/21/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "ShelfViewController.h"
#import "BookCellNib.h"
#import "AddRemoveBooksHelper.h"
#import "BookDetailsViewController.h"
#import "SelectShelfViewController.h"
#import "Filter.h"
#import "FilterSelectionViewController.h"

@interface ShelfViewController () <UITableViewDelegate, UITableViewDataSource, FilterSelectionViewControllerDelegate, BookCellNibDelegate, SelectShelfViewControllerDelegate>
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
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        if(error!=nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error getting shelf" message:@"There was an error loading your shelf" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self reloadShelf];
            }];
            [alert addAction:retryAction];

            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            self.booksInShelf = books;
            self.filteredBooksInShelf = self.booksInShelf;
            [self.tableView reloadData];
            
            if(self.booksInShelf.count==0){
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
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
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        Book *bookToRemove = self.filteredBooksInShelf[indexPath.row];
        [AddRemoveBooksHelper removeBook:bookToRemove fromArray:self.shelfName withCompletion:^(NSError * _Nonnull error) {
            [self reloadShelf];
            completionHandler(YES);
        }];
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = [UIColor systemRedColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
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
