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
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *pagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearPublishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *inShelfLabel;

@property (weak, nonatomic) IBOutlet UILabel *alsoByAuthorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *authorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIImageView *heartOverlayView;

@property (nonatomic) bool isFavorite;
@property (strong, nonatomic) NSArray<Book *> *authorsBooksArray;

@end

@implementation BookDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLabelAlphas:0];
    [self setCollectionViewAlpha:0];
    [self setBasicLabels];
    [self checkInShelves];
    
    self.authorCollectionView.delegate = self;
    self.authorCollectionView.dataSource = self;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 2;
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)setBasicLabels{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.authorsString;
    if(self.book.coverArtThumbnail!=nil){
        [self.coverArtView setImageWithURL:[NSURL URLWithString: self.book.coverArtThumbnail]];
    }
    else{
        self.coverArtView.image = [UIImage imageNamed:@"NoImageAvailable"];
    }
}

- (void)setBook:(Book *)book{
    _book = book;
    [self checkFavorite];
}

-(void)checkFavorite{
    PFRelation *relation = [PFUser.currentUser relationForKey:@"favorites"];
    PFQuery *relationQuery = [relation query];
    [relationQuery whereKey:@"bookID" equalTo:self.book.bookID];
    __weak __typeof (self) weakSelf = self;
    [relationQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        __strong __typeof (self) strongSelf = weakSelf;
        if(object!=nil){
            strongSelf.isFavorite = YES;
        }
        else{
            strongSelf.isFavorite = NO;
        }
        [strongSelf setupView];
    }];
}

-(void)checkInShelves{
    PFQuery *readQuery = [[PFUser.currentUser relationForKey:@"Read"] query];
    [readQuery whereKey:@"bookID" equalTo:self.book.bookID];
    __weak __typeof (self) weakSelf = self;
    [readQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        __strong __typeof (self) strongSelf = weakSelf;
        if(object!=nil){
            strongSelf.inShelfLabel.text = @"Read";
            self.inShelfLabel.backgroundColor = [UIColor colorWithRed:10/255.0 green:0 blue:86/255.0 alpha:1];
            return;
        }
    }];
    PFQuery *readingQuery = [[PFUser.currentUser relationForKey:@"Reading"] query];
    [readingQuery whereKey:@"bookID" equalTo:self.book.bookID];
    [readingQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        __strong __typeof (self) strongSelf = weakSelf;
        if(object!=nil){
            strongSelf.inShelfLabel.text = @"Reading";
            self.inShelfLabel.backgroundColor = [UIColor colorWithRed:10/255.0 green:0 blue:86/255.0 alpha:1];
            return;
        }
    }];
    self.inShelfLabel.text = @"Not in Shelf";
    self.inShelfLabel.backgroundColor = [UIColor grayColor];
}

-(void)setupView{
    [self refreshFavoriteButton];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    [self.yearPublishedLabel setText:[formatter stringFromDate:self.book.publishedDate]];
    
    if(self.book.pages!=nil)
        self.numPagesLabel.text = [NSString stringWithFormat:@"%@", self.book.pages];
    else
        self.numPagesLabel.text = @"Not Available";
    
    GoogleBooksAPIManager *manager = [[GoogleBooksAPIManager alloc] init];
    __weak __typeof (self) weakSelf = self;
    [manager getBookWithBookID:self.book.bookID andCompletion:^(NSDictionary * _Nonnull bookDict, NSError * _Nonnull error) {
        __strong __typeof (self) strongSelf = weakSelf;
        NSDictionary *volumeInfo = bookDict[@"volumeInfo"];
        if(volumeInfo[@"subtitle"]!=nil)
            strongSelf.subtitleLabel.text = volumeInfo[@"subtitle"];
        else
            [strongSelf.subtitleLabel setText:nil];
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
        else{
            if(self.book.categories == nil)
                strongSelf.categoriesStringLabel.text = @"None";
            else
                strongSelf.categoriesStringLabel.text = [self.book.categories componentsJoinedByString:@", "];
        }
        [UIView animateWithDuration:0.2 animations:^{
            [strongSelf setLabelAlphas:1];
        }];
    }];
    if(![self.book.authorsString containsString:@"Unknown"]){
        [manager getBooksForAuthors:self.book.authorsString andCompletion:^(NSArray * _Nonnull books, NSError * _Nonnull error) {
            __strong __typeof (self) strongSelf = weakSelf;
            if(books!=nil && books.count>0){
                strongSelf.authorsBooksArray = books;
                [strongSelf.authorCollectionView reloadData];
                [UIView animateWithDuration:0.1 animations:^{
                    [strongSelf setCollectionViewAlpha:1];
                }];
            }
        }];
    }
}
-(void)setLabelAlphas:(int)alpha{
    self.authorLabel.alpha = alpha;
    self.subtitleLabel.alpha = alpha;
    self.publishedLabel.alpha = alpha;
    self.categoriesLabel.alpha = alpha;
    self.pagesLabel.alpha = alpha;
    self.yearPublishedLabel.alpha = alpha;
    self.categoriesStringLabel.alpha = alpha;
    self.numPagesLabel.alpha = alpha;
    self.descriptionLabel.alpha = alpha;
}
-(void)setCollectionViewAlpha:(int)alpha{
    self.alsoByAuthorLabel.alpha = alpha;
    self.authorCollectionView.alpha = alpha;
}

-(void)refreshFavoriteButton{
    if (self.isFavorite == YES){
        __weak __typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            self.favoriteButton.transform = CGAffineTransformMakeScale(.8, .8);
        } completion:^(BOOL finished) {
            __strong __typeof(self) strongSelf = weakSelf;
            [UIView animateWithDuration:0.1 animations:^{
                [strongSelf.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                [strongSelf.favoriteButton setTintColor:[UIColor redColor]];
                strongSelf.favoriteButton.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    else{
        __weak __typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            self.favoriteButton.transform = CGAffineTransformMakeScale(.8, .8);
        } completion:^(BOOL finished) {
            __strong __typeof(self) strongSelf = weakSelf;
            [UIView animateWithDuration:0.1 animations:^{
                [strongSelf.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
                [strongSelf.favoriteButton setTintColor:[UIColor blackColor]];
                strongSelf.favoriteButton.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    __weak __typeof(self) weakSelf = self;
    if(self.isFavorite == YES){
        [AddRemoveBooksHelper removeFromFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if(!error){
                strongSelf.isFavorite = NO;
                [strongSelf refreshFavoriteButton];
            }
        }];
    }
    
    else{
        [AddRemoveBooksHelper addToFavorites:self.book withCompletion:^(NSError * _Nonnull error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if(!error){
                strongSelf.isFavorite = YES;
                
                if([sender isKindOfClass:[UIGestureRecognizer class]]){
                    [UIView animateWithDuration:0.2 animations:^{
                        strongSelf.heartOverlayView.alpha = 1;
                        strongSelf.heartOverlayView.transform =CGAffineTransformMakeScale(1.2, 1.2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 animations:^{
                            strongSelf.heartOverlayView.transform = CGAffineTransformIdentity;
                            strongSelf.heartOverlayView.alpha = 0;
                        }];
                    }];
                }
                
                [strongSelf refreshFavoriteButton];
            }
        }];
    }
}
- (IBAction)didDoubleTap:(id)sender {
    [self didTapFavorite:sender];
}

#pragma mark - SelectShelfViewControllerDelegate
- (void)didUpdateShelf{
    [self checkInShelves];
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
