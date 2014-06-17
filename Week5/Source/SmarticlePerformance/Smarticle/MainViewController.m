#import "MainViewController.h"
#import "ListViewController.h"
#import "LoadingSpinnerView.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mostViewedButton;
@property (weak, nonatomic) IBOutlet UIButton *mostEmailedButton;
@property (weak, nonatomic) IBOutlet UIButton *mostSharedButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *portraitConstraints;
@property (strong, nonatomic) NSArray *landscapeConstraints;
@end

@implementation MainViewController

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[ListViewController class]])
    {
        ListViewController *listViewController = [segue destinationViewController];
        
        if (sender == self.mostViewedButton)
        {
            listViewController.articleType = ArticleTypeMostViewed;
        }
        else if (sender == self.mostEmailedButton)
        {
            listViewController.articleType = ArticleTypeMostEmailed;
        }
        else if (sender == self.mostSharedButton)
        {
            listViewController.articleType = ArticleTypeMostShared;
        }
        else
        {
            listViewController.articleType = ArticleTypeFavorites;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *landscapeConstraints = [NSMutableArray array];
    
    NSDictionary *views = @{@"mostViewedButton"  : self.mostViewedButton,
                            @"mostEmailedButton" : self.mostEmailedButton,
                            @"mostSharedButton"  : self.mostSharedButton,
                            @"favoritesButton"   : self.favoritesButton};
    
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"|-[mostViewedButton]-[mostEmailedButton]-[mostSharedButton]-[favoritesButton]-|"
                            options:NSLayoutFormatAlignAllCenterY
                            metrics:nil
                            views:views];
    [landscapeConstraints addObjectsFromArray:constraints];
    
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:self.mostViewedButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.mostViewedButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0.0];
    [landscapeConstraints addObject:aspectRatio];
    
    aspectRatio = [NSLayoutConstraint constraintWithItem:self.mostEmailedButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.mostEmailedButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0.0];
    [landscapeConstraints addObject:aspectRatio];
    
    aspectRatio = [NSLayoutConstraint constraintWithItem:self.mostSharedButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.mostSharedButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0.0];
    [landscapeConstraints addObject:aspectRatio];
    
    aspectRatio = [NSLayoutConstraint constraintWithItem:self.favoritesButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.favoritesButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0.0];
    [landscapeConstraints addObject:aspectRatio];
    
    
    
    self.landscapeConstraints = landscapeConstraints;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        [self.view removeConstraints:self.portraitConstraints];
        [self.view addConstraints:self.landscapeConstraints];
    }
    else
    {
        [self.view removeConstraints:self.landscapeConstraints];
        [self.view addConstraints:self.portraitConstraints];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
