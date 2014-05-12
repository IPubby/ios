# Smart Factory iOS Week 1 Exercise  #

## A maze of twisty little passages ##

This week you'll be building a text adventure game in Objective-C.

We'll take inspiration from one of the first computer games ever created, [*Colossal Cave Adventure*](http://en.wikipedia.org/wiki/Colossal_Cave_Adventure) written in 1976-77 by William Crowther and Don Woods for the PDP-10.

Try out a web version of the original [here](http://www.web-adventures.org/cgi-bin/webfrotz?s=Adventure).

## Setting up the project ##

1. Install Xcode.  It is found in the Developer tools section of the  App Store.
2. Open a Terminal
3. Clone the repository:
4. Select File->Open... and choose the Adventure.xcodeproj file.

## Structure ##

At the top-level of the project, there are 5 folders (or groups in Xcode parlance).

### Adventure ###

 - The application code including the source files (.h and .m) files
 - Interface Builder documents (.xib)
 - Configuration files

### Adventure Tests ###

 - Unit tests (.m files).
 - Unit test configuration files

### External ###

- Third-party dependencies

### Frameworks ###

- Apple provided framework dependencies

### Products ###

- Compiled app binary
- Compiled test bundle

## Building ##

When you first open the project, the Adventure target will be selected by default.

Hit the play button to run the project in the simulator, or use the Cmd+R keyboard shortcut.

## Testing ##

Select Product -> Test, or use the Cmd+U keyboard shortcut.

## Playing ##

When the simulator opens, you'll see empty view with a text field at the bottom.  Tap the text field to bring up the keyboard and try typing anything and hit enter.  You will probably see:

	> derp

	You are standing in the Office.

You can already tell this is going to be a fun game.  Try this:

	> walk east

	You are standing in the Parts room.

Exhilarating, no?

## Rooms ##

For now, we'll be focusing on the `Room` and `Adventure` classes.  Take a moment to read through these classes.

A few things to notice:

- The Adventure class conforms to the `AdventureResponder` protocol and implements the `reponseForInput:` method.
- In `init` the Adventure class creates a few Room objects and sets up the connections between those rooms.  There is some beautiful ascii art depicting the rooms.

## Create an Item class ##

1. Open the Adventure.xcodeproj in Xcode
2. Open the Project Navigator by selecting View -> Navigators -> Show Project Navigator
3. In the Project Navigator (tree view of files), right-click on the Adventure folder and select New File
4. Select Objective-C Class
5. Enter `Item` as the class name
6. Click Next
7. Click Create
8. Customize the Item class

## Extensions ##

- Expand the adventure by adding more rooms
- Add locked doors which the player must use specific keys to open
- Monster encounters and the ability to fight monsters
- Magic words which warp you to different places on the map
- A help command to explain which commands are supported
