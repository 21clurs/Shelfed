//
//  BookDetailsViewController.m
//  Shelfed
//
//  Created by Clara Kim on 7/13/20.
//  Copyright © 2020 Clara Kim. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Book.h"
#import "AddRemoveBooksHelper.h"
#import "UploadCollectionViewController.h"
#import "SelectShelfViewController.h"
#import "GoogleBooksAPIManager.h"
#import "NSString+NSStringStripHTML.h"
#import "BookCollectionCell.h"

@interface BookDetailsViewController () <SelectShelfViewControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearPublishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *alsoByAuthorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *authorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) bool isFavorite;
@property (strong, nonatomic) NSArray<Book *> *authorsBooksArray;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.authorCollectionView.delegate = self;
    self.authorCollectionView.dataSource = self;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 2;
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setBook:(Book *)book{
    _book = book;
    [self checkFavorite];
    
}

-(void)checkFavorite{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *relationQuery = [relation query];
    [relationQuery whereKey:@"bookID" equalTo:self.book.bookID];
    __weak typeof (self) weakSelf = self;
    [relationQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        __strong typeof (self) strongSelf = weakSelf;
        if(object!=nil){
            strongSelf.isFavorite = YES;
            //self.book = (Book *) object;
        }
        else{
            strongSelf.isFavorite = NO;
        }
        [strongSelf setupView];
    }];
}

-(void)setupView{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.authorsString;
    if(self.book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL:[NSURL URLWithString: self.book.coverArtThumbnail]];
    }
    else{
        self.coverArtView.image = [UIImage imageNamed:@"NoImageAvailable"];
    }
    [self refreshFavoriteButton];
    
    self.publishedLabel.alpha = 0;
    self.categoriesLabel.alpha = 0;
    self.yearPublishedLabel.alpha = 0;
    self.categoriesStringLabel.alpha = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    [self.yearPublishedLabel setText:[formatter stringFromDate:self.book.publishedDate]];
    
    [self.categoriesStringLabel setText:[self.book.categories componentsJoinedByString:@", "]];
    
    self.descriptionLabel.alpha = 0;
    GoogleBooksAPIManager *manager = [[GoogleBooksAPIManager alloc] init];
    __weak typeof (self) weakSelf = self;
    [manager getBookWithBookID:self.book.bookID andCompletion:^(NSDictionary * _Nonnull bookDict, NSError * _Nonnull error) {
        __strong typeof (self) strongSelf = weakSelf;
        NSDictionary *volumeInfo = bookDict[@"volumeInfo"];
        if(volumeInfo[@"description"] != nil)
            strongSelf.descriptionLabel.text = [volumeInfo[@"description"] stringByStrippingHTML];
        else
            strongSelf.descriptionLabel.text = @"No description available.";
        if(volumeInfo[@"categories"]!=nil){
            NSMutableSet<NSString *> *categoriesSet = [[NSMutableSet alloc] init];
            for(NSString *categoryStr in volumeInfo[@"categories"]){
                NSArray *temp = [categoryStr componentsSeparatedByString:@" / "];
                [categoriesSet addObjectsFromArray:temp];
            }
            [categoriesSet removeObject:@"General"];
            strongSelf.categoriesStringLabel.text = [[categoriesSet allObjects]  componentsJoinedByString:@", "];
        }
        [UIView animateWithDuration:0.2 animations:^{
            strongSelf.descriptionLabel.alpha = 1;
            strongSelf.publishedLabel.alpha = 1;
            strongSelf.categoriesLabel.alpha = 1;
            strongSelf.yearPublishedLabel.alpha = 1;
            strongSelf.categoriesStringLabel.alpha = 1;
        }];
    }];
    
    self.alsoByAuthorLabel.alpha = 0;
    self.authorCollectionView.alpha = 0;
    [manager getBooksForAuthors:self.book.authorsString andCompletion:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
        __strong typeof (self) strongSelf = weakSelf;
        strongSelf.authorsBooksArray = books;
        [strongSelf.authorCollectionView reloadData];
        [UIView animateWithDuration:0.1 animations:^{
            strongSelf.alsoByAuthorLabel.alpha = 1;
            strongSelf.authorCollectionView.alpha = 1;
        }];
    }];
}
-(void)refreshFavoriteButton{
    if (self.isFavorite == YES){
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            self.favoriteButton.transform = CGAffineTransformMakeScale(.8, .8);
        } completion:^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            [UIView animateWithDuration:0.1 animations:^{
                [strongSelf.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                [strongSelf.favoriteButton setTintColor:[UIColor redColor]];
                strongSelf.favoriteButton.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    else{
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            self.favoriteButton.transform = CGAffineTransformMakeScale(.8, .8);
        } completion:^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            [UIView animateWithDuration:0.1 animations:^{
                [strongSelf.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
                [strongSelf.favoriteButton setTintColor:[UIColor blackColor]];
                strongSelf.favoriteButton.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    __weak typeof(self) weakSelf = self;
    if(self.isFavorite == YES){
        [AddRemoveBooksHelper removeFromFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            if(!error){
                strongSelf.isFavorite = NO;
                [strongSelf refreshFavoriteButton];
            }
        }];
    }
    else{
        [AddRemoveBooksHelper addToFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            if(!error){
                strongSelf.isFavorite = YES;
                [strongSelf refreshFavoriteButton];
            }
        }];
    }
}

#pragma mark - SelectShelfViewControllerDelegate
- (void)didUpdateShelf{
    //No-Op
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.authorsBooksArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BookCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCollectionCell" forIndexPath:indexPath];
    cell.book = self.authorsBooksArray[indexPath.item];
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showUploadsSegue"]){
        UploadCollectionViewController *uploadCollectionViewController = [segue destinationViewController];
        uploadCollectionViewController.book = self.book;
    }
    else if([segue.identifier isEqualToString:@"selectShelfSegue"]){
        Book *book = self.book;
        UINavigationController *navigationController = [segue destinationViewController];
        SelectShelfViewController *selectShelfViewController = (SelectShelfViewController *)[navigationController topViewController];
        selectShelfViewController.addBook = book;
        selectShelfViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"toAnotherBookSegue"]){
        BookCollectionCell *selectedCell = sender;
        NSIndexPath *indexPath = [self.authorCollectionView indexPathForCell:selectedCell];
        Book *book = self.authorsBooksArray[indexPath.item];
        
        BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
        bookDetailsViewController.book = book;
    }
}


@end
