Lab 6.1
---
In this lab, we'll tackle adding unit tests to Smarticle.

Objectives
---
- Write your fist Objective-C unit test

Testing ArticleCell
---
Let's write a very simple unit test for ArticleCell.

### Creating an XCTestCase ###

First, we need to create a new test case.

1. Open the SmarticleTesting project from the Week 6 repo.
2. File -> New -> Cocoa Touch -> Objective-C test case class
3. Name this file ArticleCellTests and be sure that it's a subclass of XCTestCase
4. Choose the SmarticleTests folder within the project folder and make sure that only the SmarticleTests target is selected.
5. You should have a new .m file (without a corresponding .h) that contains a setUp, tearDown and testExample method.
6. Run the tests by clicking Product -> Test and you should see that textExample fails.  If not, make sure you closely follow the previous steps.

### Testing Cell Creation ###

Next, we'll need to get an actual instance of ArticleCell that we can run tests against.

First, import ArticleCell by adding the following at the top of file

```objective-c
#import "ArticleCell.h"
```

Next, setup a property on ArticleCellTests where we can store a new cell.  In the interface at the top (remember, there's no .h file here), add this property:

```objective-c
@property (nonatomic, strong) ArticleCell *cell;
```

ArticleCell is defined in ArticleCell.xib, so we can't just initialize it with alloc/init.   We'll need to load it from the nib in the same way that UIKit does when it creates our cell.  To do this, we'll use UINib to load the nib manaully.

In ```-setUp```, add these lines after the super call:

```objective-c
UINib *articleCellNib = [UINib nibWithNibName:@"ArticleCell" bundle:nil];     // 1
NSArray *nibContents = [articleCellNib instantiateWithOwner:nil options:nil]; // 2
self.cell = [nibContents firstObject];                                        // 3
```

This code does the following:

1. Finds and loads the "ArticleCell.xib" file in the bundle.
2. Instantiates the objects in the nib, assigning each their classes and connecting any IBOutlets or IBActions configured in the nib.  This returns an array of all the top-level objects in the nib, since there can be many.
3. Retrieves the first of these objects assigning it to cell, since we know that there is only one in this case.

Now that we've created a cell in setUp, we can define as many test* methods as we want that test various aspects of that cell.

Open ArticleCell.m and read over its implementation.  We need a way to make sure that the 3 outlets defined on ArticleCell (abstractLabel, favoriteLabel, and titleLabel) are not nil when the cell loads.  Easy enough, except for one problem.  We've defined these properties on the "private" class extension in ArticleCell.m, therefore our tests won't be able to access them.  

It turns out there are several approaches to this problem:

1. We could make these properties public by moving them to the header file
2. We could separate them out into their own "ArticleCell+Private.h" header file, signaling that only implementors or tests should be allowed to import this interface.  This is in no way enforced by the compiler however.
3. Redeclare this same class extension in ArticleCellTests.m to "trick" the compiler into giving us access to these "private" properties.

None of these approaches are particularly elegant. Let's explore option 3 as it also makes a good point about the dynamic nature of Objective-C.

Add the following to ArticleCellTests.m, just below the import statements:

```objective-c
@interface ArticleCell ()

@property (nonatomic, weak) IBOutlet UILabel *abstractLabel;
@property (nonatomic, weak) IBOutlet UILabel *favoriteLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
```

Notice that this is just a copy of the "private" interface declared in ArticleCell.m.  This is far from ideal, but the upside is that now we can access any of these properties on our testing cell without a peep from the compiler.  At runtime, it turns out that Objective-C doesn't much care where these properties are declared.

Now that we have access to the cell's internals, let's test that the IBOutlets that we're configured in the nib are actually connected.  Start by deleting the ```-testExample``` method provided by the template and create a new method ```-testOutletConnections``` or something similiar.

Add the following assertions to your test method.

```objective-c
XCTAssertNotNil(self.cell.abstractLabel, @"Abstract label should not be nil");
XCTAssertNotNil(self.cell.favoriteLabel, @"Favorite label should not be nil");
XCTAssertNotNil(self.cell.titleLabel, @"Title label should not be nil");
```

Run the test, this time by clicking the empty diamond to left of the test method.  This tells Xcode to run only that test and skip all the rest.  If all went well, the empty diamond should have filled with a green check.

Next, write your own test method that verifies that when we set an article on the cell, its labels are updated appropriately.
