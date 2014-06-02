#import "DetailViewController.h"
#import "ArticlesController.h"

@interface DetailViewController () <UIWebViewDelegate>

#pragma mark - Private Properties

/// Button that the user can tap on to favorite an item.
///
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;

#pragma mark - IBOutlets

/// Button to navigate back in the web view.
///
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;

/// Web view to display the article contents.
///
@property (nonatomic, weak) IBOutlet UIWebView *webView;

/// Toolbar to contain web view controls for navigating backwards/forwards/reloading, etc.
///
@property (nonatomic, weak) IBOutlet UIToolbar *webViewToolbar;

#pragma mark - IBActions

/// Invoked when the user taps the back button. Navigates backward in the web view.
///
/// @param sender
///     The object that received the tap to invoke this method.
///
- (IBAction)didPressBackButton:(id)sender;

/// Invoked when the user taps the favorite button on the detail view. This method currently just
/// toggles the Favorite button on and off and doesn't update the model.
///
/// @param sender
///     The object that received the tap to invoke this method.
///
- (IBAction)didPressFavoriteButton:(id)sender;

@end

@implementation DetailViewController

#pragma mark - IBActions

- (IBAction)didPressBackButton:(id)sender
{
    [self.webView goBack];
}

- (IBAction)didPressFavoriteButton:(id)sender
{
    if (self.article.isFavorite == YES)
    {
        [[ArticlesController sharedInstance] removeFavoriteArticle:self.article];
        [self.favoriteButton setTitle:@"☆"];
    }
    else
    {
        [[ArticlesController sharedInstance] addFavoriteArticle:self.article];
        [self.favoriteButton setTitle:@"★"];
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.article.title;

    NSURL *articleURL = [NSURL URLWithString:self.article.url];
    NSURLRequest *articleRequest = [NSURLRequest requestWithURL:articleURL];
    [self.webView loadRequest:articleRequest];

    CGFloat webViewToolbarHeight = self.webViewToolbar.frame.size.height;
    UIEdgeInsets webViewContentInset = UIEdgeInsetsMake(0.0, 0.0, webViewToolbarHeight, 0.0);
    self.webView.scrollView.contentInset = webViewContentInset;
    self.webView.scrollView.scrollIndicatorInsets = webViewContentInset;

    self.favoriteButton = [[UIBarButtonItem alloc] initWithTitle:@"☆"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(didPressFavoriteButton:)];

    self.navigationItem.rightBarButtonItem = self.favoriteButton;

    if (self.article.isFavorite == YES)
    {
        [self.favoriteButton setTitle:@"★"];
    }
    else
    {
        [self.favoriteButton setTitle:@"☆"];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backButton.enabled = self.webView.canGoBack;
}

@end
