//
//  HomeViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "BookCell.h"
#import "GoogleBooksAPIManager.h"
#import "BookDetailsViewController.h"
//#import "GoodreadsAPIManager.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *books;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    GoogleBooksAPIManager *manager = [GoogleBooksAPIManager new];
    [manager defaultHomeQuery:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
        self.books = books;
        [self.tableView reloadData];
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.books.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    cell.book = self.books[indexPath.row];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BookCell *tappedCell =  sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *book = self.books[indexPath.row];
    
    BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
    bookDetailsViewController.book = book;
}


@end
