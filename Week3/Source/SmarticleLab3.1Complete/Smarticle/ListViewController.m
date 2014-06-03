#import "ListViewController.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticlesController.h"
#import "DetailViewController.h"
#import "ArticleProvider.h"

@interface ListViewController () <ArticleProviderDelegate>

#pragma mark - Private Properties

@property (nonatomic, strong) ArticleProvider *articles;

@end

@implementation ListViewController

#pragma mark - ArticlesProviderDelegate

- (void)provider:(id)provider didLoadDataAtIndexes:(NSIndexSet *)indexes
{
    [self.tableView reloadData];
}

- (void)provider:(id)provider didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drat!"
                                                    message:@"We're sorry, we can't get any articles at the moment. Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.numberOfArticles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    ArticleCell *cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Article *article = [self.articles articleAtIndex:indexPath.row];

    if (article)
    {
        cell.titleLabel.text = article.title;
    }
    else
    {
        cell.titleLabel.text = nil;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [self.articles articleAtIndex:indexPath.row];

    if (article)
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        detailViewController.article = article;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.articles = [[ArticleProvider alloc] initWithResourceType:ArticleProviderResourceTypeMostEmailed];
    self.articles.delegate = self;
    [self.articles reload];
}

@end
