//
//  FilterSelectionViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/27/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "FilterSelectionViewController.h"
#import "FilterByPagesCell.h"
#import "FilterByPublishCell.h"
#import "FilterByGenreCell.h"

@interface FilterSelectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2)
        return 4;
    else
        return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
         FilterByPagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPagesCell"];
        if(indexPath.row == 0)
            cell.lessThan = YES;
        else
            cell.lessThan = NO;
        return cell;
    }
    else if(indexPath.section == 1){
        FilterByPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPublishCell"];
        if(indexPath.row == 0)
            cell.beforeYear = YES;
        else
            cell.beforeYear = NO;
        return cell;
    }
    else{
        FilterByGenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByGenreCell"];
        switch (indexPath.row) {
            case 0:
                cell.genre = @"Fiction";
                break;
            case 1:
                cell.genre = @"Nonfiction";
                break;
            case 2:
                cell.genre = @"Juvenile Fiction";
                break;
            default:
                cell.genre = @"Other";
                break;
        }
        return cell;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Page Count";
            break;
        case 1:
            return @"Year Published";
            break;
        default:
            return @"Genre";
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 40;                  //FIX THIS LATER
    else
        return 20;
}
- (IBAction)didTapApplyFilters:(id)sender {
    [self.delegate applyFilters];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
