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

@interface ShelfViewController () <UITableViewDelegate, UITableViewDataSource, BookCellNibDelegate, SelectShelfDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *titlesInShelf;

@end

@implementation ShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     
    self.title = self.shelfName;
    
    [self reloadShelf];
}

-(void) reloadShelf{
    if(PFUser.currentUser[self.shelfName]!=nil){
        self.titlesInShelf = PFUser.currentUser[self.shelfName];
   }
   else{
       self.titlesInShelf = [[NSArray alloc] init];
       PFUser.currentUser[self.shelfName] = self.titlesInShelf;
       [PFUser.currentUser saveInBackground];
   }
   
   if(self.titlesInShelf.count==0){
       self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   }
        [self.tableView reloadData];
    }

#pragma mark - BookCellNibDelegate
- (void)didRemove{
    // No-op
}
- (void)didTapMore:(Book *)book{
    [self performSegueWithIdentifier:@"selectShelfSegue" sender:book];
}

#pragma mark - SelectShelfDelegate
- (void)didUpdateShelf{
    [self reloadShelf];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesInShelf.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCellNib *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"BookCellNib" bundle:nil] forCellReuseIdentifier:@"bookReusableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableCell"];
    }

   [AddRemoveBooksHelper getBookForID:self.titlesInShelf[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
       if(!error){
           cell.book = book;
       }
       else{
           NSLog(@"Error getting book for ID");
       }
   }];
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
        /*
        Book *bookToRemove = self.favoriteBooks[indexPath.row];
        [AddRemoveBooksHelper removeFromFavorites:bookToRemove withCompletion:^(NSError * _Nonnull error) {
            [self reloadFavorites];
            completionHandler(YES);
        }];
        */
        __weak typeof(self) weakSelf = self;
        [AddRemoveBooksHelper getBookForID:self.titlesInShelf[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
            if(!error){
                [AddRemoveBooksHelper removeBook:book fromArray:self.shelfName withCompletion:^(NSError * _Nonnull error) {
                    [weakSelf reloadShelf];
                    completionHandler(YES);
                }];
            }
            else{
                NSLog(@"Error getting book for ID");
            }
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
        [AddRemoveBooksHelper getBookForID:self.titlesInShelf[indexPath.row] withCompletion:^(Book *book, NSError * _Nullable error) {
            if(!error){
                BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
                bookDetailsViewController.book = book;
            }
            else{
                NSLog(@"Error getting book for ID");
            }
        }];
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
