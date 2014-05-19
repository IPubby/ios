# Lab 2.1 #

## Objectives ##

- Become familiar with using Interface Builder.
- Create a user interface for your app using a Storyboard.
- Use the target-action pattern to allow your view controller to react to events from a view.

## Suggested Resources ##

- [View Controller Programming Guide for iOS](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/Introduction/Introduction.html)
- [View Controller Catalog for iOS](https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/ViewControllerCatalog/Introduction.html)


## Creating a Storyboard ##

1.  File > New > File...
2.  User Interface > Storyboard
3.  Use the name "Main" and choose Device Family iPhone.
4.  Choose a folder and hit "Create"".

## Using the Storyboard as your interface ##

1.  Delete the first three lines in `application:didFinishLaunchingWithOptions:` leaving only the return statement.
2.  Select the Smarticle target and enter "Main.storyboard" under General > Deployment Info > Main Interface
3.  Create an empty view controller by dragging a view controller out from the object browser into the Storyboard workspace.
3.  Run again now to make sure you see a white screen and not a black one.

## Creating a Custom View Controller for a Storyboard ##

1.  Create a new UIViewController subclass and name it MainViewController.  Leave the "Targeted for iPad" and "With XIB for user interface" unchecked.
2.  Open the storyboard and click on the view controller you created earlier.
3.  Select the identity inspector (third icon from the right in the right hand pane).
4.  Under Custom Class enter MainViewController.
5.  Run again.  Nothing should have changed.
6. Let's set the backgroundColor of our view controller's view so we can verify that it's there.  In MainViewController's `-(void)viewDidLoad` method:
	```Objective-C
	- (void)viewDidLoad
	{
		[super viewDidLoad];
		// Do any additional setup after loading the view.

		self.view.backgroundColor = [UIColor magentaColor];
	}
	```
7.  Run again and you should see a nice looking magenta view.


## Adding a button ##

1.  Drag a UIButton over from the object browser into the new view controller
2.  Notice that little dotted lines appear when you have the button completely centered.  These guides ensure that the button is exactly centered.

## Creating an IBOutlet ###

1. Open Main.storyboard
2. Open the Assistant Editor (View > Assistant Editor > Show Assistant Editor).  A second editor will appear in split screen.
3. Select "Main View Controller" inside the storyboard from Document Outline (the left toolbar).  The right hand editor should automatically display MainViewController.m.  If it doesn't, select "Automatic" from the right hand jump bar.
4. Control click the button you just created
5. A small window will appear containing a table of entries with empty circles to the right of each.
6. Click and drag a blue line starting from the empty circle next to "New Referencing Outlet" over to the private `@interface` section of your view controller.
7. As you hold it there, a horizontal blue line will appear, showing you where code is about to be inserted.
8. Let go and a new popover will appear allowing you to name and configure an IBOutlet.
9. Use the following options to configure the outlet
	a. Connection: Outlet
	b. Name: articlesButton
	c. Type: UIButton
	d. Storage: Weak
10. Click connect and a new IBOutlet will appear.
11. In your `- (void)viewDidLoad` method:
	```Objective-C
	- (void)viewDidLoad
	{
		[super viewDidLoad];
		// Do any additional setup after loading the view.

		self.articlesButton.backgroundColor = [UIColor yellowColor];
	}
	```
12. Run the project and behold, a yellow button!

## Creating an IBAction ##

1. Open Main.storyboard
2. Open the Assistant Editor
3. Select "Main View Controller" and MainViewController.m should appear in the right hand editor.
4. Control the click the button again and you'll see the same popover as before.
5. This time clicka and drag the empty circle next to "Sent Events" > "Touch Up Inside" over to the private `@interface` section of your view controller.
6. A popover will appear once again, but this time use these options:
	a. Connection: Action
	b. Name: showArticles
	c. Type: id
	d. Event: Touch Up Inside
	e. Arguments: Sender
7.  Click Connect and a new IBAction method definition will appear, both in the interface and in the implementation.
8.  In the implementation of `showArticles:` add the following:
	
```Objective-C
- (IBAction)showArticles:(id)sender 
{
	NSLog(@"Congrats! You pressed this button: %@", sender);
}
```

Hit the play button to run the project again.


This is nice and all but we actually want to be able to do more than just print a log.  We also want the ability to display multiple view controllers.  In order to do that, there are several builtin view controllers which have the ability to manage your custom view controllers.  We're going to set up our app to use a UINavigationController so that in the next step, we'll have a way to display something other than our amazing one button interface.

## Setting up a Navigation Controller ##

1. Open Main.storyboard
2. Drag a Navigation Controller into the canvas.
3. When you do this, two view controllers will be added automatically, a UINavigationController and a UITableViewController.   For now, we are only interested in the UINavigationController so select the table view controller and hit the delete key.
4. The arrow coming from the ether identifies the window's root view controller.  We want to change the root to be our navigation controller.  Pluck the arrow off of Main View Controller and attach it to the Navigation Controller.
5. Now control click the Navigation Controller and a popover will appear with empty circles again.
6. Connect the "root view controller" segue to the Main View Controller.
7. Run the project.  You should see that there is now a title bar at the top of your previously bare view controller.
8. In the storyboard, select the Navigation Item underneath the Main View Controller Scene.
9. In the Attributes inspector (fourth icon from the left in the right hand pane), set the Navigation Item's title to "Main".
10. Run the project again and notice that the title appears.

