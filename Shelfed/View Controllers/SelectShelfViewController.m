//
//  SelectShelfViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/22/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "SelectShelfViewController.h"
#import "Parse/Parse.h"
#import "ShelfCell.h"
#import "AddRemoveBooksHelper.h"

@interface SelectShelfViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *shelvesArray;

@end

@implementation SelectShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    if(PFUser.currentUser[@"userShelves"]!=nil){
        self.shelvesArray = PFUser.currentUser[@"userShelves"];
    }
    else{
        self.shelvesArray = [[NSMutableArray alloc] init];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger shelvesCount = 0;
    if(PFUser.currentUser[@"userShelves"]!=nil){
        shelvesCount = ((NSMutableArray *)PFUser.currentUser[@"userShelves"]).count;
    }
    return shelvesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShelfCell"];
    cell.shelfName = self.shelvesArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    __weak typeof(self) weakSelf = self;
    [AddRemoveBooksHelper addBook:self.addBook toArray:self.shelvesArray[indexPath.row] withCompletion:^(NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(error!=nil){
            NSLog(@"Error adding book to shelf");
        }
        else{
            [strongSelf.delegate didUpdateShelf];
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ShelfCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSString *shelf = self.shelvesArray[indexPath.item];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
