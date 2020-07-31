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
#import "Filter.h"

@interface FilterSelectionViewController () <UITableViewDelegate, UITableViewDataSource, FilterByPagesCellDelegate, FilterByPublishCellDelegate, FilterByGenreCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray<Filter *> *filtersArray;

@end

@implementation FilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.filtersArray == nil)
        self.filtersArray = [[NSMutableArray alloc] init];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (IBAction)didTapApplyFilters:(id)sender {
    for(UITableViewCell *cell in [self.tableView visibleCells]){
        if([cell isSelected] == YES){
            Filter *filter;
            if([cell isKindOfClass:[FilterByPagesCell class]]){
                filter = [((FilterByPagesCell *)cell) makeFilterFromCell];
            }
            else if([cell isKindOfClass:[FilterByPublishCell class]]){
                filter = [((FilterByPublishCell *)cell) makeFilterFromCell];
            }
            else if([cell isKindOfClass:[FilterByGenreCell class]]){
                filter = [((FilterByPublishCell *)cell) makeFilterFromCell];
            }
            if(filter!=nil)
                [self.filtersArray addObject:filter];
        }
    }
    [self.delegate applyFilters:self.filtersArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FilterByPagesCellDelegate

#pragma mark - FilterByPublishCellDelegate

#pragma mark - FilterByGenreCellDelegate


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
        if(indexPath.row == 0){
            cell.lessThan = YES;
            // [cell setSelected: self.pagesPublishSelectedDict[@"PagesLess"] animated:NO];
        }
        else{
            cell.lessThan = NO;
            // [cell setSelected: self.pagesPublishSelectedDict[@"PagesGreater"] animated:NO];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1){
        FilterByPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPublishCell"];
        if(indexPath.row == 0){
            cell.beforeYear = YES;
            // [cell setSelected: self.pagesPublishSelectedDict[@"PublishedBefore"] animated:NO];
        }
        else{
            cell.beforeYear = NO;
            // [cell setSelected: self.pagesPublishSelectedDict[@"PublishedAfter"] animated:NO];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        // [cell setSelected:[self.genresSelectedArray containsObject:cell.genre] animated:NO];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 40;                  //FIX THIS LATER
    else
        return 20;
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
