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

@interface UploadCollectionViewController () < UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout /*, UIImagePickerControllerDelegate, UINavigationControllerDelegate*/ >
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation UploadCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 2;
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int numberOfCellsPerRow = 3;
    CGFloat cellWidth = (self.collectionView.frame.size.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - self.flowLayout.minimumInteritemSpacing*(numberOfCellsPerRow-1))/numberOfCellsPerRow;
    cellWidth = floor(cellWidth);
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)onAddUploadTap{
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UploadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UploadCollectionCell" forIndexPath:indexPath];
    if(indexPath.item ==0){
        cell.uploadPhotoView.image = [UIImage systemImageNamed:@"plus.circle.fill"];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(onAddUploadTap)];
        [cell addGestureRecognizer:tapRecognizer];
    }
    
    else{
        
    }
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize size = CGSizeMake(200, 200);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
};

@end
