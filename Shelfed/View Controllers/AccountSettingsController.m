//
//  AccountSettingsController.m
//  Shelfed
//
//  Created by Clara Kim on 8/10/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "AccountSettingsController.h"
#import "UploadPhotoViewController.h"
#import "SetUsernameCell.h"
#import "SetPasswordCell.h"

@interface AccountSettingsController () <UploadPhotoViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, SetUsernameCellDelegate, SetPasswordCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *updatePhotoContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSNumber *> *cellTypesArray;
@property (nonatomic) UploadPhotoViewController *uploadPhotoViewController;
@end

@implementation AccountSettingsController

bool passwordSaved;
bool usernameSaved;

- (void)viewDidLoad {
    self.cellTypesArray = @[@(UsernameSettingType), @(PasswordSettingType)];
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.updatePhotoContainerView addGestureRecognizer:tapRecognizer];
}

- (void) onTap:(UITapGestureRecognizer *)sender{
    self.uploadPhotoViewController.delegate = self;
    [self.uploadPhotoViewController onTap];
}
- (IBAction)didTapSave:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountSettingsNotification" object:self];
}

#pragma mark - UploadPhotoViewControllerDelegate
- (void)containerViewController:(UploadPhotoViewController *)uploadPhotoViewController presentActionSheet:(UIAlertController *)actionSheet{
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)containerViewController:(UploadPhotoViewController *)uploadPhotoViewController presentImagePicker:(UIImagePickerController *)imagePicker{
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)removeCurrentPhoto{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTypesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case UsernameSettingType:{
            SetUsernameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetNameCell"];
            cell.delegate = self;
            return cell;
            break;
        }
        default:{
            SetPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetPasswordCell"];
            cell.delegate = self;
            return cell;
            break;
        }
    }
}

#pragma mark - SetUsernameCellDelegate
-(void)usernameSaved:(bool)success withMessage:(NSString *)message{
    if(success){
        usernameSaved = YES;
        if(passwordSaved ==YES)
            [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Updating Username" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - SetPasswordCellDelegate
-(void)passwordSaved:(bool)success withMessage:(NSString *)message{
    if(success){
        passwordSaved = YES;
        if(usernameSaved ==YES)
           [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Updating Password" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"selectPhotoSegue"]){
        if([segue.destinationViewController isKindOfClass:[UploadPhotoViewController class]]){
            self.uploadPhotoViewController = [segue destinationViewController];
            self.uploadPhotoViewController.showEdit = YES;
        }
    }
}


@end
