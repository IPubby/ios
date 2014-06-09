#import "ListViewController.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticlesController.h"
#import "DetailViewController.h"
#import "LoadingSpinnerView.h"

/// Identifier for article cells for reuse. This value must match the identifier specified for the
/// cell in the storyboard.
///
static NSString *CellIdentifier = @"ArticleCell";

@interface ListViewController ()

#pragma mark - Private Properties

/// Article cell to use for height calculations.
///
@property (nonatomic, strong) ArticleCell *articleCellForHeight;

/// List of articles to display in the list.
///
@property (nonatomic, strong) NSArray *articles;

/// The currently loaded offset from the current results set.
///
@property (nonatomic, assign) NSUInteger currentOffset;

/// The offset that is currently loading or will be loaded the next time reloadArticles is called.
///
@property (nonatomic, assign) NSUInteger loadingOffset;

@property (nonatomic, strong) LoadingSpinnerView *loadingSpinner;

/// The total number of articles available in the results set.
///
@property (nonatomic, assign) NSUInteger totalNumberOfArticles;

#pragma mark - Private Methods

/// Whether or not there are more articles available to load.
///
/// @return
///     YES if more articles can be loaded from the current offset; NO otherwise.
///
- (BOOL)canLoadMoreArticles;

/// Whether or not articles are currently being loaded.
///
/// @return
///     YES if the receiver is in the midst of loading articles; NO otherwise.
///
- (BOOL)isLoadingArticles;

/// Reloads articles from the articles controller.
///
/// If there are more articles to load and no articles are currently loading, reloads the articles
/// from the articles controller asynchronously.
///
- (void)reloadArticles;

@end

@implementation ListViewController

#pragma mark - Private Methods

- (BOOL)canLoadMoreArticles
{
    return self.currentOffset + 20 < self.totalNumberOfArticles;
}

- (BOOL)isLoadingArticles
{
    return self.currentOffset != self.loadingOffset;
}

- (void)reloadArticles
{
    if (self.currentOffset != self.loadingOffset)
    {
        [self.loadingSpinner startAnimating];
        
        [[ArticlesController sharedInstance] getArticlesForArticleType:self.articleType
                                                                 offset:self.loadingOffset
                                                      completionHandler:^(NSArray *articles,
                                                                          NSNumber *numberOfResults,
                                                                          NSError *error)
         {
             self.currentOffset = self.loadingOffset;
             [self.loadingSpinner stopAnimating];
             
             if (error)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drat!"
                                                                 message:@"We're sorry, we can't get any articles at the moment. Please try again later."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
             else
             {
                 if (self.articles == nil)
                 {
                     self.articles = articles;
                     self.totalNumberOfArticles = [numberOfResults unsignedIntegerValue];
                 }
                 else
                 {
                     self.articles = [self.articles arrayByAddingObjectsFromArray:articles];
                 }
                 
                 [self.tableView reloadData];
             }
         }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        if ([self isLoadingArticles] == NO && [self canLoadMoreArticles] == YES)
        {
            self.loadingOffset = self.currentOffset + 20;

            [self reloadArticles];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCell *cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.article = [self.articles objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [self.articles objectAtIndex:indexPath.row];
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

    self.articleCellForHeight.article = [self.articles objectAtIndex:indexPath.row];

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

    self.navigationController.navigationBar.barTintColor = [[Settings sharedInstance] colorForArticleType:self.articleType];

    switch (self.articleType)
    {
        case ArticleTypeFavorites:
            self.title = @"Favorites";
            break;

        case ArticleTypeMostEmailed:
            self.title = @"Most Emailed";
            break;

        case ArticleTypeMostShared:
            self.title = @"Most Shared";
            break;

        case ArticleTypeMostViewed:
            self.title = @"Most Viewed";
            break;
    }

    self.loadingSpinner = [[LoadingSpinnerView alloc] initWithFrame:self.view.bounds];
    self.loadingSpinner.color = [[Settings sharedInstance] colorForArticleType:self.articleType];
    self.loadingSpinner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.loadingSpinner];

    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil]
         forCellReuseIdentifier:CellIdentifier];

    self.currentOffset = -1;
    [self reloadArticles];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
}

@end
