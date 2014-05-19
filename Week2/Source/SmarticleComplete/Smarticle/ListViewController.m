#import "ListViewController.h"
#import "Article.h"
#import "DetailViewController.h"

@interface ListViewController ()

#pragma mark - Private Properties

/// List of articles to display in the list.
///
@property (nonatomic, strong) NSArray *articles;

@end

@implementation ListViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Default Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Article *article = [self.articles objectAtIndex:indexPath.row];
    cell.textLabel.text = article.title;
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
    self.articles = [Article demoArticles];
}

@end
