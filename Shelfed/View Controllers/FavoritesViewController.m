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

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BookCellNibDelegate, SelectShelfViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Book *> *favoriteBooks;

@end

@implementation FavoritesViewController

- (void)viewWillAppear:(BOOL)animated{
    [self reloadFavorites];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self reloadFavorites];
}

-(void) reloadFavorites{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        self.favoriteBooks = [books mutableCopy];
        if(self.favoriteBooks.count==0){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        [self.tableView reloadData];
    }];
    
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
    return self.favoriteBooks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookCellNib *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"BookCellNib" bundle:nil] forCellReuseIdentifier:@"bookReusableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    }
    
    cell.book = self.favoriteBooks[indexPath.row];
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
        
        Book *bookToRemove = self.favoriteBooks[indexPath.row];
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
        bookDetailsViewController.book = self.favoriteBooks[indexPath.row];
        

    }
    else if([segue.identifier isEqualToString:@"selectShelfSegue"]){
        //NSString *bookID = sender;
        Book *book = sender;
        UINavigationController *navigationController = [segue destinationViewController];
        SelectShelfViewController *selectShelfViewController = (SelectShelfViewController *)[navigationController topViewController];
        selectShelfViewController.addBook = book;
        selectShelfViewController.delegate = self;
    }
    /*
    BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
    bookDetailsViewController.book = self.favoriteBooks[indexPath.row];
    */
}

@end
