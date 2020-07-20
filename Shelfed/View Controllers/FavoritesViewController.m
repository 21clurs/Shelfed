//
//  FavoritesViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/15/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Parse/Parse.h"
#import "BookCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BookDetailsViewController.h"
//#import "EmptyTableView.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *favorites;

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
}

- (void)getBookForID: (NSString *)bookID withCompletion:(void(^)(Book *book, NSError * _Nullable error)) completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
    [query whereKey:@"bookID" equalTo:bookID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            Book *book = objects[0];
            completion(book, nil);
        } else {
            NSLog(@"Could not find book in Book...");
            completion(nil,error);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favorites.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    [self getBookForID:self.favorites[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
        if(!error){
            cell.book = book;
        }
        else{
            NSLog(@"Error getting book for ID");
        }
    }];
    //cell.book
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *placeholderImage =  [[UIImage systemImageNamed:@"book"] imageWithTintColor:UIColor.darkGrayColor];
    return placeholderImage;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"Mark books as favorites and see them here";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    BookCell *tappedCell =  sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    //Book *book;
    [self getBookForID:self.favorites[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
        if(!error){
            //book = book;
            BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
            bookDetailsViewController.book = book;
        }
        else{
            NSLog(@"Error getting book for ID");
        }
    }];
    
    
}



@end
