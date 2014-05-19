## Lab 2.4: DetailViewController

### Introduction

For this lab, we'll be adding a detail view to the Smarticle demo app.

### Objectives

- Gain an understanding of standalone nib files
- Display details in response to a tap on a table view cell
- More practice with properties, targets, and outlets

### Additional Resources

- [About Table Views in iOS Apps](https://developer.apple.com/library/ios/documentation/userexperience/conceptual/tableview_iphone/AboutTableViewsiPhone/AboutTableViewsiPhone.html#//apple_ref/doc/uid/TP40007451-CH1-SW1)
- [TableView Fundamentals for iOS](https://developer.apple.com/library/ios/samplecode/TableViewSuite/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007318)

### Development Setup

1. Clone the GitHub repository: `git@github.com:gosmartfactory/ios.git`
2. Browse to the following directory: `Week2/Source/Smarticle`
3. Open the app in Xcode by double-clicking the project file: `Smarticle`
4. Run the app in the simulator by clicking on the Play icon or click on `Product -> Run`

### Display a Generic Table View via a Segue

Let's add a table view controller to our main storyboard and display it when the user taps the `Articles` button.

1. In Xcode, select `Main.storyboard` in the Project Navigator to open the storyboard.
2. Open the Utilities view: View > Utilities > Show Object Library.
3. Click on the Table View Controller item and drag it to your storyboard.
4. Control-click on the `Articles` button and drag a blue line to the new Table View Controller.
5. Select `Push` from the segue options.
6. Click the Play button to run the app in the simulator.

When the app runs in the simulator, you should be able to reveal a generic table view controller by clicking on the `Articles` button. There won't be any data in the table view yet!

### Update the Generic Table View to be ListViewController Instead

1. Open `Main.storyboard`.
2. Select the table view controller.
3. Open the Identity Inspector: View > Utilities > Show Identity Inspector.
4. In the `Custom Class` field, enter `ListViewController`.
5. Select the Table View Cell on the storyboard. In the Attributes Inspector (View > Utilities > Show Attributes Inspector), select `Basic` in the style dropdown.
6. Enter `Default Cell` in the `Reuse Identifier` text box.
7. Click the Play button to run the app in the simulator.

To confirm that `ListViewController` is being displayed, you can place a breakpoint in the `viewDidLoad` method in `ListViewController.m`.

Add a breakpoint on line 37 by clicking on the line number in the gutter in Xcode. A blue marker should appear in the gutter to indicate that you've placed a breakpoint.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];                          // Add a breakpoint to this line.
    self.articles = [Article demoArticles];
}
```

Click the Play button in Xcode to run the app. Xcode should display the breakpoint for you when you tap on the Articles button.

### Fill in the `UITableViewDataSource` Methods

1. Open `ListViewController.m`.
2. Uncomment lines 19 through 21.
3. Replace the empty methods with implementations like the examples below.

```objective-c
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
```

Click the Play button to run the app in the simulator.

When the app runs in the simulator, you'll see that the table view lists 99 blank table view cells. Let's replace the placehoder values with "realer" data.

```objective-c
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
```

Click the Play button in Xcode to run the app in the simulator. When the app runs, you should see a list of demo data articles when you tap on the `Articles` button.
