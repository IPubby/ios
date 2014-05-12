#import "AdventureViewController.h"
#import "AdventureCell.h"

static NSString * const AdventureCellIdentifier = @"AdventureCellIdentifier";

@interface AdventureViewController () <UITextFieldDelegate,
                                       UITableViewDataSource,
                                       UITableViewDelegate>

#pragma mark - Private outlets

/// A table view that displays all the lines of the adventure, including the input typed by the user.
///
/// This view controller acts as both the data source and the delegate of this table view, providing
/// the dimensions and content for each row of the table view.
///
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// The text field at the bottom of the view that allows the user to input messages.
///
/// This view controller acts as the delegate of this text field, responding to messages sent as a
/// result of the user's edits to its contents.
///
@property (weak, nonatomic) IBOutlet UITextField *textField;

/// The layout contraint connecting the bottom of the text field to the bottom of the view.
///
/// This constraint is adjusted to accomodate the keyboard when it appears or disappears.
///
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldBottomSpace;

/// The list of NSString objects representing the entries displayed in the table view.
///
@property (strong, nonatomic) NSMutableArray *entries;

#pragma mark - Private methods

/// Called in response to the notification that the keyboard is about to appear.
///
/// @param notification
///     The notification instance that was sent.
///
- (void)keyboardWillAppear:(NSNotification *)notification;


/// Called in response to the notificaiton that the keyboard is about to disappear.
///
/// @param notification
///     The notification instance that was sent.
///
- (void)keyboardWillDisappear:(NSNotification *)notification;

@end

@implementation AdventureViewController

#pragma mark - Init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        _entries = [NSMutableArray array];
        
        self.title = @"Adventure";
    }
    
    return self;
}

#pragma mark - UIViewController overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AdventureCell" bundle:nil]
         forCellReuseIdentifier:AdventureCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, 0.0, 0.0);
}

#pragma mark - Keyboard notifications

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.textFieldBottomSpace.constant = -keyboardFrame.size.height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillDisappear:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.textFieldBottomSpace.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdventureCell *cell = [tableView dequeueReusableCellWithIdentifier:AdventureCellIdentifier];
    cell.entryLabel.text = self.entries[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reply = self.entries[indexPath.row];
    
    CGRect rect = [reply boundingRectWithSize:CGSizeMake(300.0, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                      context:nil];
    
    
    return MAX(ceilf(rect.size.height) + 10.0, 44.0);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Retrieve the reply
    NSString *reply = [self.responder responseForInput:textField.text];
    
    // Format the input
    NSString *input = [@"> " stringByAppendingString:textField.text];
    
    // Add both to entries
    [self.entries addObject:input];
    [self.entries addObject:reply];
    
    [self.tableView reloadData];
    
    // Scroll to the bottom of the entries.
    NSIndexPath *bottomRow = [NSIndexPath indexPathForRow:self.entries.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:bottomRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    // Clear the text field.
    textField.text = @"";
    
    return YES;
}

@end
