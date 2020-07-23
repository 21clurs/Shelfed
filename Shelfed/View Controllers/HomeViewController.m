//
//  HomeViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "BookCellNib.h"
#import "GoogleBooksAPIManager.h"
#import "BookDetailsViewController.h"
#import "InfiniteScrollActivityView.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "SelectShelfViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, BookCellNibDelegate, SelectShelfDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray<Book *> *books;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

GoogleBooksAPIManager *manager;
InfiniteScrollActivityView *loadingMoreView;
UIRefreshControl *refreshControl;

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [self reloadFeed];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    manager = [GoogleBooksAPIManager new];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self reloadFeed];
    
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
}
- (void)reloadFeed{
    __weak typeof(self) weakSelf = self;
    [manager reloadBooks:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            NSLog(@"Error getting default feed!");
        }
        else{
            strongSelf.books = [books mutableCopy];
            [strongSelf.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
    }];
    [refreshControl endRefreshing];
}

- (void)loadMore{
    __weak typeof(self) weakSelf = self;
    [manager loadMoreBooks:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(books){
            strongSelf.isMoreDataLoading = false;
            
            [loadingMoreView stopAnimating];
            
            [strongSelf.books addObjectsFromArray:books];
            [strongSelf.tableView reloadData];
        }
        else{
            NSLog(@"Error loading more data");
        }
    }];
}
#pragma mark - BookCellNibDelegate
- (void)didRemove{
    // No-Op
}
- (void)didTapMore:(Book *)book{
    [self performSegueWithIdentifier:@"selectShelfSegue" sender:book];
}
#pragma mark - SelectShelfDelegate
- (void)didUpdateShelf{
    // No-Op
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.books.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookCellNib *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"BookCellNib" bundle:nil] forCellReuseIdentifier:@"bookReusableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    }
    cell.book = self.books[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self performSegueWithIdentifier:@"bookDetailsSegue" sender:indexPath];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *searchableText = searchText;
    searchableText = [[searchableText componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
    searchableText = [[searchableText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@"+"];
    
    __weak typeof(self) weakSelf = self;
    [manager searchBooks:searchableText andCompletion:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            NSLog(@"Error searching!");
        }
        else{
            strongSelf.books = [books mutableCopy];
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    __weak typeof (self) weakSelf = self;
    [manager searchBooks:@"" andCompletion:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            NSLog(@"Error searching!");
        }
        else{
            strongSelf.books = [books mutableCopy];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y>scrollOffsetThreshold && self.tableView.isDragging){
            self.isMoreDataLoading = true;
            
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            [self loadMore];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"bookDetailsSegue"]){
        //BookCellNib *tappedCell =  sender;
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        NSIndexPath *indexPath = sender;
        Book *book = self.books[indexPath.row];
        
        BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
        bookDetailsViewController.book = book;
    }
    else if([segue.identifier isEqualToString:@"selectShelfSegue"]){
        Book *book = sender;
        UINavigationController *navigationController = [segue destinationViewController];
        SelectShelfViewController *selectShelfViewController = (SelectShelfViewController *)[navigationController topViewController];
        selectShelfViewController.addBook = book;
        selectShelfViewController.delegate = self;
    }
}


@end
