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

@interface FilterSelectionViewController () <UITableViewDelegate, UITableViewDataSource, FilterByPagesCellDelegate, FilterByPublishCellDelegate, FilterByGenreCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableDictionary<NSString *,Filter *> *filtersDict;

@end

NSArray<NSString *> *genreArray;

@implementation FilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    genreArray = [[NSArray alloc] initWithObjects:@"Fiction", @"Nonfiction", @"Juvenile Fiction", @"Other", nil];
    
    if(self.filtersArray == nil)
        self.filtersArray = [[NSMutableArray alloc] init];
    else{
        self.filtersDict = [[NSMutableDictionary alloc] init];
        [self makeFiltersDictFromFilters];
    }
    
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
                filter = [((FilterByGenreCell *)cell) makeFilterFromCell];
            }
            if(filter!=nil)
                [self.filtersArray addObject:filter];
        }
    }
    [self.delegate applyFilters:self.filtersArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapClear:(id)sender {
    [self.filtersArray removeAllObjects];
    [self.filtersDict removeAllObjects];
    [self.tableView reloadData];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void) makeFiltersDictFromFilters{
    for(Filter *filter in self.filtersArray){
        if(filter.genre!=nil)
            [self.filtersDict setObject:filter forKey:filter.genre];
        else
            [self.filtersDict setObject:filter forKey:filter.filterTypeString];
    }
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
        return genreArray.count;
    else
        return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        FilterByPagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPagesCell"];
        if(indexPath.row == 0){
            cell.lessThan = YES;
            
            if([self.filtersDict objectForKey:@"PagesLess"]!=nil){
                cell.pageCountString = [NSString stringWithFormat:@"%d",[self.filtersDict objectForKey:@"PagesLess"].pages];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        else{
            cell.lessThan = NO;
            if([self.filtersDict objectForKey:@"PagesGreater"]!=nil){
                cell.pageCountString = [NSString stringWithFormat:@"%d",[self.filtersDict objectForKey:@"PagesGreater"].pages];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1){
        FilterByPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPublishCell"];
        if(indexPath.row == 0){
            cell.beforeYear = YES;
            if([self.filtersDict objectForKey:@"PublishedBefore"]!=nil){
                cell.yearString = [NSString stringWithFormat:@"%d",[self.filtersDict objectForKey:@"PublishedBefore"].year];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        else{
            cell.beforeYear = NO;
            if([self.filtersDict objectForKey:@"PublishedAfter"]!=nil){
                cell.yearString = [NSString stringWithFormat:@"%d",[self.filtersDict objectForKey:@"PublishedAfter"].year];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        FilterByGenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByGenreCell"];
        cell.genre = genreArray[indexPath.row];
        if([self.filtersDict objectForKey:cell.genre]!=nil){
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(indexPath.row == genreArray.count - 1) //Reach end of loading/making all cells
            [self.filtersArray removeAllObjects];
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
