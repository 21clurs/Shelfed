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

@interface UploadDetailsViewController () <FBSDKSharingDialog>
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UIView *fbShareButtonView;

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

- (void)setupFBShareButton{
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = self.uploadImage;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];

    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(dosomething:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    [button setExclusiveTouch:YES];
    [self.fbShareButtonView addSubview:button];
    */
    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
    
    
    
    button.shareContent = content;
    button.frame = CGRectMake(0, 0, self.fbShareButtonView.frame.size.width-35, self.fbShareButtonView.frame.size.height);
    [self.fbShareButtonView addSubview:button];
     
}
- (void)dosomething:(UIButton *)sender{
    
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
