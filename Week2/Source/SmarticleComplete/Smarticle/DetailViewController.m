#import "DetailViewController.h"

@interface DetailViewController ()

#pragma mark - Private Properties

/// Private property to configure the detail view with the title of our article property.
///
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

#pragma mark - IBActions

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

- (IBAction)didPressFavoriteButton:(id)sender
{
    NSLog(@"Favorite button tapped for article: %@", self.article.title);
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.article.title;
}

@end
