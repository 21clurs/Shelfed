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

bool shouldClear;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.filtersDataSource == nil){
        [self makeFiltersDataSource];
    }
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)makeFiltersDataSource{
    Filter *filterPagesLess = [[Filter alloc] initLengthFilterWithPages:@"" andLessThan:YES];
    Filter *filterPagesGreater = [[Filter alloc] initLengthFilterWithPages:@"" andLessThan:NO];
    Filter *filterBeforeYear = [[Filter alloc] initYearFilterWithYear:@"" andBefore:YES];
    Filter *filterAfterYear = [[Filter alloc] initYearFilterWithYear:@"" andBefore:NO];
    
    Filter *filterGenreFiction = [[Filter alloc] initGenreFilterWithGenre:@"Fiction"];
    Filter *filterGenreNonfiction = [[Filter alloc] initGenreFilterWithGenre:@"Nonfiction"];
    Filter *filterGenreYA = [[Filter alloc] initGenreFilterWithGenre:@"Juvenile Fiction"];
    Filter *filterGenreOther = [[Filter alloc] initGenreFilterWithGenre:@"Other"];
    
    self.filtersDataSource = @{
      @(FilterSectionTypePages) : @[filterPagesLess, filterPagesGreater],
      @(FilterSectionTypeYear) : @[filterBeforeYear, filterAfterYear],
      @(FilterSectionTypeGenre) : @[filterGenreFiction, filterGenreNonfiction, filterGenreYA, filterGenreOther],
    };
}

- (IBAction)didTapApplyFilters:(id)sender {
    [self.delegate appliedFilters:self.filtersDataSource];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapClear:(id)sender {
    shouldClear = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.filtersDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filtersDataSource[@(section)].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Filter *filter =  self.filtersDataSource[@(indexPath.section)][indexPath.row];
    switch (indexPath.section) {
        case FilterSectionTypePages:{
            FilterByPagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPagesCell"];
            cell.filter = filter;
            if(shouldClear == YES){
                cell.pageCountString = @"";
                filter.pages = 0;
            }
            cell.pageCountString = [NSString stringWithFormat:@"%d",filter.pages];

            if(filter.selected)
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case FilterSectionTypeYear:{
            FilterByPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPublishCell"];
            cell.filter = filter;
            if(shouldClear == YES){
                cell.yearString = @"";
                filter.year = 0;
            }
            cell.yearString = [NSString stringWithFormat:@"%d",filter.year];
            
            if(filter.selected)
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        default:{
            shouldClear = NO;
            
            FilterByGenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByGenreCell"];
            cell.filter = filter;
            cell.genre = filter.genre;
            
            if(filter.selected)
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case FilterSectionTypePages:
            return @"Page Count";
            break;
        case FilterSectionTypeYear:
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

@end
