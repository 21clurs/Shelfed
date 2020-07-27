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

@interface ShelfViewController () <UITableViewDelegate, UITableViewDataSource, BookCellNibDelegate, SelectShelfViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSArray<NSString *> *titlesInShelf;
@property (strong, nonatomic) NSArray<Book *> *booksInShelf;

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
    
    [self reloadShelf];
}

-(void) reloadShelf{
    PFRelation *relation = [PFUser.currentUser relationForKey:self.shelfName];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Book *> * _Nullable books, NSError * _Nullable error) {
        self.booksInShelf = books;
        [self.tableView reloadData];
        
        if(self.booksInShelf.count==0){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }];
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
    return self.booksInShelf.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCellNib *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    cell.book = self.booksInShelf[indexPath.row];
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
        
        Book *bookToRemove = self.booksInShelf[indexPath.row];
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
        bookDetailsViewController.book = self.booksInShelf[indexPath.row];
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
