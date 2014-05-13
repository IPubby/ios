## Lab 1.2: AdventureResponder

### Introduction

For this lab, we'll be building a text adventure game in Objective-C. We were inspired from one of the first computer games ever created, [*Colossal Cave Adventure*](http://en.wikipedia.org/wiki/Colossal_Cave_Adventure) written in 1976-77 by William Crowther and Don Woods for the PDP-10.

Try out a web version of the original [here](http://www.web-adventures.org/cgi-bin/webfrotz?s=Adventure)!

### Objectives

- Get familiar with protocols by building your own `AdventureResponder`
- Learn about classes by creating an `Item` class
- Expand the adventure by adding rooms

### Additional Resources

- [Working with Protocols](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithProtocols/WorkingwithProtocols.html)

### Development Setup

1. Clone the GitHub repository: `git@github.com:gosmartfactory/ios.git`
2. Browse to the following directory: `Week1/Source`
3. Open the app in Xcode by double-clicking the project file: `Adventure`
4. Run the app in the simulator by clicking on the Play icon or click on `Product -> Run`

**Tip** This app requires iOS 7 or later. If you see an error or the app crashes, make sure that you have an iOS 7.1 Simulator selected. You can change the simulator version by clicking on the Device drop down menu next to the Play and Stop buttons. For example, click on "iPhone > iOS 6.1" (or whichever device is currently displayed), and select "iPhone Retina (4-inch) > iOS 7.1".

### Playing

When the simulator opens, you'll see empty view with a text field at the bottom. Tap the text field to bring up the keyboard and try typing anything and hit enter. You will probably see:

	> derp

	You are standing in the Office.

You can already tell this is going to be a fun game. Try this:

	> walk east

	You are standing in the Parts room.

Exhilarating, no?

### Rooms

For now, we'll be focusing on the `Room` and `Adventure` classes.  Take a moment to read through these classes.

A couple things to note:

- The Adventure class conforms to the `AdventureResponder` protocol and implements the `reponseForInput:` method.
- In `init` the Adventure class creates a few Room objects and sets up the connections between those rooms. (Check out the sweet ASCII art depicting the rooms!)

#### Add a Room

1. Switch over to Xcode
2. Open the Project Navigator by selecting View -> Navigators -> Show Project Navigator
3. In the Project Navigator (tree view of files), select Adventure.m
4. Add a Broom closet room after `workshop` starting on line 47:

For example, your code might look like the following, starting on line 47 after `workshop` is initialized.

```objective-c
    Room *closet = [[Room alloc] initWithName:@"Broom closet"];
    [workshop setSouthEntranceTo:closet];
    self.rooms = [NSSet setWithObjects:office, partsRoom, assemblyRoom, workshop, closet, nil];
```

### Create an Item Class

1. In the Project Navigator (tree view of files), right-click on the Adventure folder and select New File
2. Select Objective-C Class
3. Enter `Item` as the class name
4. Click Next
5. Click Create
6. Customize the Item class

### Create Your Own AdventureResponder

1. In the Project Navigator (tree view of files), right-click on the Adventure folder and select New File
2. Select Objective-C Class
3. Enter `MyAmazingAdventure` as the class name
4. Customize the class to implement the `AdventureResponder` protocol
5. Customize the class based on `Adventure.h` and `Adventure.m`
6. Update `AppDelegate.m` to include your `MyAmazingAdventure.h` header file and assign an instance of `MyAmazingAdventure` to `self.responder` on line 24.

For #5 above, here are some ideas to try:

* Upate your `MyAmazingAdventure` `init` method to set up a different room structure than `Adventure`.
* Add `Items` to your rooms. (Hint: You could add an `NSArray` property to the Room class to keep a list of items available in the room.)
* Add some additional logic to the `responseForInput:` method to implement one of the Extensions listed below.

### Extensions

- Expand the adventure by adding more rooms
- Add locked doors which the player must use specific keys to open
- Monster encounters and the ability to fight monsters
- Magic words which warp you to different places on the map
- A help command to explain which commands are supported
