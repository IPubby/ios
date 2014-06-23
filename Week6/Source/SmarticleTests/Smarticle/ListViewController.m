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

#pragma mark - Public Methods

- (void)setArticles:(ArticleProvider *)articles
{
    _articles = articles;
    _articles.delegate = self;
}

#pragma mark - Private Methods

- (void)configureView
{
    if (self.articles)
    {
        UIColor *articleColor = [[Settings sharedInstance] colorForArticleType:self.articles.articleType];
        
        self.navigationController.navigationBar.barTintColor = articleColor;
        self.loadingSpinner.color = articleColor;
        
        [self.articles reload];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.articles isLoading])
    {
        [self.loadingSpinner startAnimating];
    }
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.articles forKey:@"articles"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.articles = [coder decodeObjectForKey:@"articles"];
}

- (void)applicationFinishedRestoringState
{
    [self configureView];
}

@end
