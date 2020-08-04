//
//  UploadCollectionViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/24/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "UploadCollectionViewController.h"
#import "UploadPhotoViewController.h"
#import "Parse/Parse.h"
#import "UploadCollectionCell.h"
#import "UIImage+UIImageUploadAdditions.h"
#import "Upload.h"
#import "UploadDetailsViewController.h"
#import "FBSDKCoreKit.h"
#import "FBSDKShareKit.h"
@import Parse;

@interface UploadCollectionViewController () < UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadDetailsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) NSArray<Upload *> *uploads;

@end

@implementation UploadCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserUploads];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 2;
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
}

-(void)getUserUploads{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"userUploads"];
    PFQuery *relationQuery = [relation query];
    if(self.book != nil){
        [relationQuery whereKey:@"associatedBookID" equalTo:self.book.bookID];
        [relationQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(objects){
                self.uploads = objects;
                [self.collectionView reloadData];
            }
        }];
    }
    else{
        [relationQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(objects){
                self.uploads = objects;
                [self.collectionView reloadData];
            }
        }];
    }
}

-(void)onAddUploadTap{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Update your profile photo" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [actionSheet addAction:cancelAction];

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    [actionSheet addAction:cameraAction];

    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose from Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self openGallery];
    }];
    [actionSheet addAction:libraryAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void) openGallery{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) openCamera{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available");
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int numberOfCellsPerRow = 3;
    CGFloat cellWidth = (self.collectionView.frame.size.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - self.flowLayout.minimumInteritemSpacing*(numberOfCellsPerRow-1))/numberOfCellsPerRow;
    cellWidth = floor(cellWidth);
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.book!=nil)
        return self.uploads.count+1;
    else
        return self.uploads.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UploadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UploadCollectionCell" forIndexPath:indexPath];
    if(self.book != nil){
        if(indexPath.item ==0){
            cell.uploadPhotoView.image = [UIImage systemImageNamed:@"plus.circle.fill"];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddUploadTap)];
            [cell addGestureRecognizer:tapRecognizer];
        }
        else{
            cell.uploadPhotoView.file = [self.uploads[indexPath.item-1] uploadImageFile];
            [cell.uploadPhotoView loadInBackground];
        }
    }
    else{
        cell.uploadPhotoView.file = [self.uploads[indexPath.item] uploadImageFile];
        [cell.uploadPhotoView loadInBackground];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if((self.book!=nil && indexPath.item >0) || self.book == nil){
        [self performSegueWithIdentifier:@"showUploadDetailsSegue" sender:indexPath];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [editedImage resizewithSize:CGSizeMake(500,500)];
    
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    
    Upload *upload = [[Upload alloc] initWithImageFile:imageData andBook:self.book];

    [upload saveUploadToParseWithCompletion:^(NSError * _Nonnull error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if(error==nil){
            [self getUserUploads];
        }
    }];
 
};

#pragma mark - UploadDetailsViewControllerDelegate
- (void)didDeleteUpload{
    [self getUserUploads];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showUploadDetailsSegue"]){
        NSIndexPath *indexPath = sender;
        UploadCollectionCell *cell = (UploadCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        UINavigationController *navigationController = [segue destinationViewController];
        UploadDetailsViewController *uploadDetailsViewController = (UploadDetailsViewController *)[navigationController topViewController];
        UIImage *image = cell.uploadPhotoView.image;
        
        Upload *upload;
        if(self.book!=nil)
            upload = self.uploads[indexPath.item-1];
        else
            upload = self.uploads[indexPath.item];
        
        uploadDetailsViewController.uploadImage = image;
        uploadDetailsViewController.upload = upload;
        uploadDetailsViewController.delegate = self;
    }
}


@end
