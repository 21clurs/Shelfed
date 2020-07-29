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

@end

@implementation FilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.pagesPublishSelectedDict == nil){
        self.pagesPublishSelectedDict = [NSMutableDictionary dictionaryWithCapacity:4];
        [self.pagesPublishSelectedDict setValue:[NSNumber numberWithBool:NO] forKey:@"PagesLess"];
        [self.pagesPublishSelectedDict setValue:[NSNumber numberWithBool:NO] forKey:@"PagesGreater"];
        [self.pagesPublishSelectedDict setValue:[NSNumber numberWithBool:NO] forKey:@"PublishedBefore"];
        [self.pagesPublishSelectedDict setValue:[NSNumber numberWithBool:NO] forKey:@"PublishedAfter"];
    }
    if(self.pagesPublishValuesDict == nil)
        self.pagesPublishValuesDict = [NSMutableDictionary dictionaryWithCapacity:4];
    if(self.genresSelectedArray == nil)
        self.genresSelectedArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
#pragma mark - FilterByPagesCellDelegate
- (void)filterWithNumPages:(int)pages lessThan:(bool)lessThan {
    if(lessThan==YES)
        self.pagesPublishValuesDict[@"PagesLess"] = [NSNumber numberWithInt:pages];
    else
        self.pagesPublishValuesDict[@"PagesGreater"] = [NSNumber numberWithInt:pages];
}
- (void)filterByPagesCellSelected:(bool)selected lessThan:(bool)lessThan{
    if(lessThan==YES)
        self.pagesPublishSelectedDict[@"PagesLess"] = [NSNumber numberWithBool:selected];
    else
        self.pagesPublishSelectedDict[@"PagesGreater"] = [NSNumber numberWithBool:selected];
}

#pragma mark - FilterByPublishCellDelegate
- (void)filterWithYear:(int)year before:(bool)before{
    if(before==YES)
        self.pagesPublishValuesDict[@"PublishedBefore"] = [NSNumber numberWithInt:year];
    else
        self.pagesPublishValuesDict[@"PublishedAfter"] = [NSNumber numberWithInt:year];
}
- (void)filterByPublishCellSelected:(bool)selected before:(bool)before{
    if(before==YES)
        self.pagesPublishSelectedDict[@"PublishedBefore"] = [NSNumber numberWithBool:selected];
    else
        self.pagesPublishSelectedDict[@"PublishedAfter"] = [NSNumber numberWithBool:selected];
}

#pragma mark - FilterByGenreCellDelegate
- (void)usingGenre:(nonnull NSString *)genre filter:(bool)filter {
    if(filter == YES)
        [self.genresSelectedArray addObject:genre];
    else
        [self.genresSelectedArray removeObject:genre];
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
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1){
        FilterByPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterByPublishCell"];
        if(indexPath.row == 0)
            cell.beforeYear = YES;
        else
            cell.beforeYear = NO;
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
- (IBAction)didTapApplyFilters:(id)sender {
    [self.delegate applyFilters:self.pagesPublishValuesDict withSelected:self.pagesPublishSelectedDict andGenres:self.genresSelectedArray];
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
