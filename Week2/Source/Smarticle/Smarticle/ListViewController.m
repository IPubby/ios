#import "ListViewController.h"
#import "Article.h"

@interface ListViewController ()

#pragma mark - Private Properties

/// List of articles to display in the list.
///
@property (nonatomic, strong) NSArray *articles;

@end

@implementation ListViewController

#pragma mark - UITableViewDataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.articles = [Article demoArticles];
}

@end
