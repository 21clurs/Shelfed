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
//#import "EmptyTableView.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BookCellNibDelegate, SelectShelfViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSArray<NSString *> *favorites;
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
    /*
    if(PFUser.currentUser[@"favoritesArray"]!=nil){
           self.favorites = PFUser.currentUser[@"favoritesArray"];
       }
       else{
           self.favorites = [[NSArray alloc] init];
           PFUser.currentUser[@"favoritesArray"] = self.favorites;
           [PFUser.currentUser saveInBackground];
       }
       
       if(self.favorites.count==0){
           self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       }
       [self.tableView reloadData];
     */
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        self.favoriteBooks = [books mutableCopy];
        [self.tableView reloadData];
        
        if(self.favoriteBooks.count==0){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
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
    
    /*
    __weak typeof(self) weakSelf = self;
    [AddRemoveBooksHelper getBookForID:self.favorites[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
        if(!error){
            cell.book = book;
            [weakSelf.favoriteBooks addObject:book];
        }
        else{
            NSLog(@"Error getting book for ID");
        }
    }];
    cell.delegate = self;
    return cell;
     */
    
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
        /*
        __weak typeof(self) weakSelf = self;
        [AddRemoveBooksHelper getBookForID:self.favorites[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
            if(!error){
                __strong typeof(self) strongSelf = weakSelf;
                [AddRemoveBooksHelper removeFromFavorites:book withCompletion:^(NSError * _Nonnull error) {
                    [strongSelf reloadFavorites];
                    completionHandler(YES);
                }];
            }
            else{
                NSLog(@"Error getting book for ID");
            }
        }];
         */
        
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
        
        /*
        [AddRemoveBooksHelper getBookForID:self.favorites[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
            if(!error){
                BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
                bookDetailsViewController.book = book;
            }
            else{
                NSLog(@"Error getting book for ID");
            }
        }];
        */
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
