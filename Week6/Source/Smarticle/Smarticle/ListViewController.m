#import "ListViewController.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticleProvider.h"
#import "ArticlesController.h"
#import "DetailViewController.h"
#import "FavoritesArticleProvider.h"
#import "LoadingSpinnerView.h"

/// Identifier for article cells for reuse. This value must match the identifier specified for the
/// cell in the storyboard.
///
static NSString *CellIdentifier = @"ArticleCell";

@interface ListViewController () <ArticleProviderDelegate>

#pragma mark - Private Properties

/// Article cell to use for height calculations.
///
@property (nonatomic, strong) ArticleCell *articleCellForHeight;

/// Provides articles to display in the list.
///
@property (nonatomic, strong) ArticleProvider *articles;

/// Loading spinner view to display while loading articles.
///
@property (nonatomic, strong) LoadingSpinnerView *loadingSpinner;

#pragma mark - Private Methods

/// Configures the view. This code used to be in viewDidLoad in earlier versions of Smarticle. Now
/// that we're using state preservation, we need to handle this separately.
///
- (void)configureView;

@end

@implementation ListViewController

#pragma mark - Private Methods

- (void)configureView
{
    if (self.articleType == ArticleTypeUnknown)
    {
        return;
    }
    
    self.navigationController.navigationBar.barTintColor = [[Settings sharedInstance] colorForArticleType:self.articleType];
    
    self.loadingSpinner.color = [[Settings sharedInstance] colorForArticleType:self.articleType];
    [self.loadingSpinner startAnimating];
    
    switch (self.articleType)
    {
        case ArticleTypeFavorites:
            self.title = @"Favorites";
            self.articles = [[FavoritesArticleProvider alloc] init];
            break;
            
        case ArticleTypeMostEmailed:
            self.title = @"Most Emailed";
            self.articles = [[ArticleProvider alloc] initWithResourceType:ArticleProviderResourceTypeMostEmailed];
            break;
            
        case ArticleTypeMostShared:
            self.title = @"Most Shared";
            self.articles = [[ArticleProvider alloc] initWithResourceType:ArticleProviderResourceTypeMostShared];
            break;
            
        case ArticleTypeMostViewed:
            self.title = @"Most Viewed";
            self.articles = [[ArticleProvider alloc] initWithResourceType:ArticleProviderResourceTypeMostViewed];
            break;
            
        case ArticleTypeUnknown:
            [NSException raise:NSInternalInconsistencyException
                        format:@"ArticleTypeUnknown is not allowed. You must specify a valid ArticleType."];
            break;
    }
    
    self.articles.delegate = self;
    [self.articles reload];
}

#pragma mark - ArticlesProviderDelegate

- (void)provider:(id)provider didLoadDataAtIndexes:(NSIndexSet *)indexes
{
    [self.loadingSpinner stopAnimating];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    if (indexPaths.count > 0)
    {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)provider:(id)provider didFailWithError:(NSError *)error
{
    [self.loadingSpinner stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drat!"
                                                    message:@"We're sorry, we can't get any articles at the moment. Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        [self.articles loadMoreArticles];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCell *cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.article = [self.articles articleAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [self.articles articleAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.article = article;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.articleCellForHeight == nil)
    {
        UINib *articleCellNib = [UINib nibWithNibName:@"ArticleCell" bundle:nil];
        self.articleCellForHeight = [[articleCellNib instantiateWithOwner:nil options:nil] firstObject];
    }
    
    Article *article = [self.articles articleAtIndex:indexPath.row];
    self.articleCellForHeight.article = article;
    
    // [self.articleCellForHeight setNeedsUpdateConstraints];
    // [self.articleCellForHeight updateConstraintsIfNeeded];
    // self.articleCellForHeight.bounds = CGRectMake(0.0, 0.0, 320.0, 100.0);
    // [self.articleCellForHeight setNeedsLayout];
    // [self.articleCellForHeight layoutIfNeeded];
    
    CGSize size = [self.articleCellForHeight.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingSpinner = [[LoadingSpinnerView alloc] initWithFrame:self.view.bounds];
    self.loadingSpinner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.loadingSpinner];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil]
         forCellReuseIdentifier:CellIdentifier];
    
    [self configureView];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%@ encodeRestorableStateWithCoder:", self);
    
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:self.articleType forKey:@"articleType"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%@ decodeRestorableStateWithCoder:", self);
    
    [super decodeRestorableStateWithCoder:coder];
    self.articleType = [coder decodeIntegerForKey:@"articleType"];
}

- (void)applicationFinishedRestoringState
{
    NSLog(@"%@ applicationFinishedRestoringState", self);
    
    [self configureView];
}

@end
