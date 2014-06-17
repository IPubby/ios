#import "DetailViewController.h"
#import "ArticleImage.h"
#import "ArticlesController.h"
#import "LoadingSpinnerView.h"
#import "UIKit+AFNetworking.h"

@interface DetailViewController () <UIActionSheetDelegate,
                                    UIAlertViewDelegate,
                                    UIScrollViewDelegate,
                                    UIWebViewDelegate>

#pragma mark - Private Properties

/// Button that the user can tap on to favorite an item.
///
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;

/// Indicates whether or not the article image has been loaded.
///
@property (nonatomic, assign) BOOL hasLoadedArticleImage;

/// Indicates whether or not the web view has started to load data.
///
@property (nonatomic, assign) BOOL hasLoadedWebViewContent;

/// Used to display a loading spinner while content is loading.
///
@property (nonatomic, strong) LoadingSpinnerView *loadingSpinnerView;

#pragma mark - IBOutlets

/// Button to display an actionsheet with options for taking action on the article in the detail
/// view.
///
@property (nonatomic, weak) IBOutlet UIBarButtonItem *actionButton;

/// Main article image view to display at the top of the detail view.
///
@property (nonatomic, weak) IBOutlet UIImageView *articleImageView;

/// Button to navigate back in the web view.
///
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;

/// Label to display the byline for the article.
///
@property (nonatomic, weak) IBOutlet UILabel *bylineLabel;

/// Button to navigate forward in the web view.
///
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardButton;

/// Label to display the date when the article was published.
///
@property (nonatomic, weak) IBOutlet UILabel *publishedLabel;

/// Label to display the section for this article. e.g. Science.
///
@property (nonatomic, weak) IBOutlet UILabel *sectionLabel;

/// View to contain the article summary: author, published date, and section.
///
@property (nonatomic, weak) IBOutlet UIView *summaryView;

/// Web view to display the article contents.
///
@property (nonatomic, weak) IBOutlet UIWebView *webView;

/// Toolbar to contain web view controls for navigating backwards/forwards/reloading, etc.
///
@property (nonatomic, weak) IBOutlet UIToolbar *webViewToolbar;

#pragma mark - Private Methods

/// Invoked when the user taps the forward button. Navigates forward in the web view.
///
- (void)configureView;

#pragma mark - IBActions

/// Invoked when the user taps the action button. Currently only allows the user to display the
/// article in Mobile Safari.
///
/// @param sender
///     The object that received the tap to invoke this method.
///
- (IBAction)didPressActionButton:(id)sender;

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

/// Invoked when the user taps the forward button. Navigates forward in the web view.
///
/// @param sender
///     The object that received the tap to invoke this method.
///
- (IBAction)didPressForwardButton:(id)sender;

@end

@implementation DetailViewController

#pragma mark - Init and Dealloc Methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        self.restorationIdentifier = @"DetailViewController";
    }

    return self;
}

- (void)dealloc
{
    self.webView.scrollView.delegate = nil;
}

#pragma mark - Private Methods

- (void)configureView
{
    self.hasLoadedArticleImage = NO;
    self.hasLoadedWebViewContent = NO;

    self.loadingSpinnerView = [[LoadingSpinnerView alloc] initWithFrame:self.view.bounds];
    self.loadingSpinnerView.color = self.navigationController.navigationBar.barTintColor;
    self.loadingSpinnerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.loadingSpinnerView];
    [self.loadingSpinnerView startAnimating];

    NSString *favoriteButtonText;

    if (self.article.isFavorite == YES)
    {
        favoriteButtonText = @"★";
    }
    else
    {
        favoriteButtonText = @"☆";
    }

    self.favoriteButton = [[UIBarButtonItem alloc] initWithTitle:favoriteButtonText
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(didPressFavoriteButton:)];

    self.navigationItem.rightBarButtonItem = self.favoriteButton;
    self.navigationItem.title = self.article.title;

    CGFloat articleImageHeight = self.articleImageView.frame.size.height;
    CGFloat webViewToolbarHeight = self.webViewToolbar.frame.size.height;

    UIEdgeInsets webViewContentInset = UIEdgeInsetsMake(articleImageHeight, 0.0, webViewToolbarHeight, 0.0);
    self.webView.scrollView.contentInset = webViewContentInset;
    self.webView.scrollView.scrollIndicatorInsets = webViewContentInset;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.delegate = self;

    self.webViewToolbar.barTintColor = self.navigationController.navigationBar.barTintColor;

    if (self.article.defaultImage != nil)
    {
        NSURL *articleImageURL = [NSURL URLWithString:self.article.defaultImage.url];
        NSURLRequest *articleImageRequest = [NSURLRequest requestWithURL:articleImageURL];

        [self.articleImageView setImageWithURLRequest:articleImageRequest placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
            self.articleImageView.image = image;
            self.hasLoadedArticleImage = YES;

            if ([self.loadingSpinnerView isAnimating] == YES && self.hasLoadedWebViewContent == YES)
            {
                [self.loadingSpinnerView stopAnimating];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
        {
            self.articleImageView.image = [UIImage imageNamed:@"no-image-placeholder"];
            self.hasLoadedArticleImage = YES;

            if ([self.loadingSpinnerView isAnimating] == YES && self.hasLoadedWebViewContent == YES)
            {
                [self.loadingSpinnerView stopAnimating];
            }
        }];
    }
    else
    {
        self.hasLoadedArticleImage = YES;
    }

    NSURL *articleURL = [NSURL URLWithString:self.article.url];
    NSURLRequest *articleRequest = [NSURLRequest requestWithURL:articleURL];
    [self.webView loadRequest:articleRequest];

    if (self.article.byline != nil && [self.article.byline isEqualToString:@""] == NO)
    {
        self.bylineLabel.text = self.article.byline;
    }

    self.publishedLabel.text = self.article.publishedDate;
    self.sectionLabel.text = self.article.section;
}

#pragma mark - IBActions

- (IBAction)didPressActionButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open in Safari", nil];

    [actionSheet showInView:self.view];
}

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

- (IBAction)didPressForwardButton:(id)sender
{
    [self.webView goForward];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // Open in Safari
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.article.url]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat articleImageHeight = self.articleImageView.frame.size.height;
    CGFloat yOffset = scrollView.bounds.origin.y;
    UIEdgeInsets webViewContentInset = self.webView.scrollView.contentInset;

    if (yOffset > -articleImageHeight && yOffset < 0.0)
    {
        CGFloat topEdgeInset = articleImageHeight - (articleImageHeight + yOffset);
        webViewContentInset.top = topEdgeInset;
        self.webView.scrollView.contentInset = webViewContentInset;
        self.webView.scrollView.scrollIndicatorInsets = webViewContentInset;

        CGRect summaryViewFrame = self.summaryView.frame;
        CGFloat summaryViewHeight = summaryViewFrame.size.height;
        summaryViewFrame.origin.y = -yOffset - summaryViewHeight;
        self.summaryView.frame = summaryViewFrame;
    }
    else if (yOffset <= -articleImageHeight)
    {
        webViewContentInset.top = articleImageHeight;
        self.webView.scrollView.contentInset = webViewContentInset;

        CGFloat topEdgeInset = articleImageHeight - (articleImageHeight + yOffset);
        webViewContentInset.top = topEdgeInset;
        self.webView.scrollView.scrollIndicatorInsets = webViewContentInset;

        CGRect summaryViewFrame = self.summaryView.frame;
        CGFloat summaryViewHeight = summaryViewFrame.size.height;
        summaryViewFrame.origin.y = -yOffset - summaryViewHeight;
        self.summaryView.frame = summaryViewFrame;
    }
    else if (yOffset >= 0.0)
    {
        webViewContentInset.top = 0.0;
        self.webView.scrollView.contentInset = webViewContentInset;
        self.webView.scrollView.scrollIndicatorInsets = webViewContentInset;

        CGRect summaryViewFrame = self.summaryView.frame;
        CGFloat summaryViewHeight = summaryViewFrame.size.height;
        summaryViewFrame.origin.y = -summaryViewHeight;
        self.summaryView.frame = summaryViewFrame;
    }
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%@ encodeRestorableStateWithCoder:", self);

    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.article forKey:@"article"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%@ decodeRestorableStateWithCoder:", self);

    [super decodeRestorableStateWithCoder:coder];
    self.article = [coder decodeObjectForKey:@"article"];
}

- (void)applicationFinishedRestoringState
{
    NSLog(@"%@ applicationFinishedRestoringState", self);
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Sometime over the weekend, nytimes.com articles were updated to have a transparent
    // background. This is a hack to make the background of the web page white again. Note that this
    // currently gets called multiple times, and it should be optimized.
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.background = 'white';"];

    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    self.hasLoadedWebViewContent = YES;

    if ([self.loadingSpinnerView isAnimating] == YES && self.hasLoadedArticleImage == YES)
    {
        [self.loadingSpinnerView stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *title = nil;
    NSString *message = [error localizedDescription];

    if (error.code == NSURLErrorNotConnectedToInternet)
    {
        title = @"Network Connection Required";
        message = @"You don't currently have a network connection. A network connection is required to view article details. Please try again later.";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
