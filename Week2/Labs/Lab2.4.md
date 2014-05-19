## Lab 2.4: DetailViewController

### Introduction

For this lab, we'll be adding a detail view to the Smarticle demo app.

### Objectives

- Practice adding files to an existing project
- Gain an understanding of standalone nib files
- Display details in response to a tap on a table view cell
- More practice with properties, targets, and outlets

### Additional Resources

- [About Table Views in iOS Apps](https://developer.apple.com/library/ios/documentation/userexperience/conceptual/tableview_iphone/AboutTableViewsiPhone/AboutTableViewsiPhone.html#//apple_ref/doc/uid/TP40007451-CH1-SW1)
- [TableView Fundamentals for iOS](https://developer.apple.com/library/ios/samplecode/TableViewSuite/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007318)

### Development Setup

1. Complete Lab 2.3 before continuing.

### Add a New View Controller to the Project

1. In Xcode, select the `Smarticle` folder in the Project Navigator.
2. Then create a new view controller: File > New > File.
3. Select `Objective-C Class`.
4. Enter `DetailViewController` in the `Class` text field.
5. Enter `UIViewController` in the `Subclass of` text field.
6. Check the `Also create XIB file` check box.
7. Select iPhone from the platform dropdown.
8. Click `Next`.
9. Click `Create`.

### Flesh Out the Detail View

Let's flesh out the detail view a bit to keep track of the selected article and include a placeholder label for the title of the article.

1. Add a public property with the type `Article *` to `DetailViewController.h`. (Note: You'll need to import `Article.h` to add a property with this type.)
2. Add a private property called `titleLabel` to `DetailViewController.m`.
3. Open the `DetailViewController.xib` and add a UILabel object and wire it up to the private property. (Note: the process for wiring up the label is the same as wiring up the button in Lab 2.2.)
4. Open `DetailViewController.m` and implement the `viewDidLoad` callback to update the `titleLabel.text` value to the title of the article.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.article.title; // Add this line to display the title of the article.
}
```

Hint: For step 1 above, you'll need to add an import line to the top of `DetailViewController.h` The top of `DetailViewController.h` should look like this when you're done:

```objective-c
#import <UIKit/UIKit.h>
#import "Article.h"

@interface DetailViewController : UIViewController
```

### Display the Detail View when Tapping on a Cell

#### Import the DetailViewController header into `ListViewController.m`

* Add `import "DetailViewController.h"` to the top of `ListViewController.m`.

```objective-c
#import "ListViewController.h"
#import "Article.h"
#import "DetailViewController.h" // Add this line to import DetailViewController.h

@interface ListViewController ()
```

#### Present Detail View Controller via a Push Transition

To display the detail view controller, we can add a few lines of code to `ListViewController.m` to implement `didSelectRowAtIndexPath`. The final code looks something like this. A description of these lines can be found below.

```objective-c
1. - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
2. {
3.     Article *article = [self.articles objectAtIndex:indexPath.row];
4.     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
5.     detailViewController.article = article;
6.     [self.navigationController pushViewController:detailViewController animated:YES];
7. }
```

Line 3: Look up the article displayed that this index based on the `indexPath` provided by the caller.

Line 4: Create a new instance of DetailViewController based on the nib file we created.

Line 5: Assign a reference to the selected article to the view controller's public `article` property.

Line 6: Display the view controller via a push transition.

### Next Steps

* Extend the detail view to include a `Favorite` button that invokes a private `IBAction` in `DetailViewController`. No need to implement this method for now. We'll work on saving and loading favorites in a future class.
* Display more details from the article on the detail view. For example, you could display the byline, abstract, or any other property that's available via the existing `Article` class.
