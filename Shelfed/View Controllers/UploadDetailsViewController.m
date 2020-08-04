//
//  UploadDetailsViewController.m
//  Shelfed
//
//  Created by Clara Kim on 8/3/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "UploadDetailsViewController.h"
#import "FBSDKCoreKit.h"
#import "FBSDKShareKit.h"
#import "AddRemoveBooksHelper.h"
#import "Parse/Parse.h"

@interface UploadDetailsViewController () <FBSDKSharingDialog>
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UIView *fbShareButtonView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteUploadButton;
@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) NSDate *dateUploaded;

@end

@implementation UploadDetailsViewController

@synthesize delegate;
@synthesize shareContent;
@synthesize shouldFailOnDataError;
@synthesize canShow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.uploadImage != nil){
        self.uploadImageView.image = self.uploadImage;
        [self setupFBShareButton];
    }
}

- (void)setUpload:(Upload *)upload{
    _upload = upload;
    
    [AddRemoveBooksHelper getBookForID:upload.associatedBookID withCompletion:^(Book * _Nonnull book, NSError * _Nullable error) {
        if(book!=nil){
            self.bookTitle = book.title;
            [self.bookTitleLabel setText:self.bookTitle];
            self.dateUploaded = upload.createdAt;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"MMMM d, yyyy";
            
            [self.uploadDateLabel setText:[formatter stringFromDate:self.dateUploaded]];
        }
    }];
}

- (void)setupFBShareButton{
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = self.uploadImage;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
    button.shareContent = content;
    button.frame = CGRectMake(0, 0, self.fbShareButtonView.frame.size.width-32, self.fbShareButtonView.frame.size.height);
    [self.fbShareButtonView addSubview:button];
}

- (IBAction)didTapDelete:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Upload"];
    [query getObjectInBackgroundWithId:self.upload.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object!= nil){
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self.delegate didDeleteUpload];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)validateWithError:(NSError *__autoreleasing  _Nullable * _Nullable)errorRef {
    return NO;
}

- (BOOL)show {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
}


@end
