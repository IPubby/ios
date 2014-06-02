#import "ListViewController.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticlesController.h"
#import "DetailViewController.h"

@interface ListViewController ()

#pragma mark - Private Properties

/// List of articles to display in the list.
///
@property (nonatomic, strong) NSArray *articles;

/// The total number of articles available in the results set.
///
@property (nonatomic, assign) NSUInteger totalNumberOfArticles;

/// The currently loaded offset from the current results set.
///
@property (nonatomic, assign) NSUInteger currentOffset;

/// The offset that is currently loading or will be loaded the next time reloadArticles is called.
///
@property (nonatomic, assign) NSUInteger loadingOffset;

#pragma mark - Private Methods

/// Reloads articles from the articles controller.
///
/// If there are more articles to load and no articles are currently loading, reloads the articles
/// from the articles controller asynchronously.
///
- (void)reloadArticles;

@end

@implementation ListViewController

#pragma mark - Private Methods

- (void)reloadArticles
{
    if (self.currentOffset != self.loadingOffset)
    {
        [[ArticlesController sharedInstance] getArticlesForResourceType:@"mostemailed"
                                                                 offset:self.loadingOffset
                                                      completionHandler:^(NSArray *articles,
                                                                          NSNumber *numberOfResults,
                                                                          NSError *error)
         {
             self.currentOffset = self.loadingOffset;
             
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
        if (self.loadingOffset == self.currentOffset)
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
    static NSString *CellIdentifier = @"ArticleCell";
    ArticleCell *cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Article *article = [self.articles objectAtIndex:indexPath.row];
    cell.titleLabel.text = article.title;
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

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadArticles];
}

@end
