## Lab 1.1: NSLog ###

### Objectives ###

- Write your first program in Objective-C!
- Learn how to debug your app using log statements
- Familiarize yourself with some of the helpful classes in Foundation
- Learn how to navigate the documentation

### Additional Resources ###

- [C Data Types](http://en.wikipedia.org/wiki/C_data_types)
- [Working with Objects](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW2)
- [String format specifiers](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html#//apple_ref/doc/uid/TP40004265-SW1)

### Development Setup ###

Download Xcode from the App Store

### 1. Create a new project ###

Open Xcode and from the launcher panel:

1. Select "Create a new Xcode project".
2. On the left pane, select OS X -> "Application".
3. Choose "Command Line Tool" and click *Next*.
4. On the following screen, enter the following:
	a. Product name: SmartFactoryLogger
	b. Organization name: SmartFactory
	c. Company identifier: com.smartfactory
	d. Type: Foundation
5. Choose a folder where the project will be created.  It might be a good idea to create a smartfactory folder inside your Home folder to hold this and any future projects.
6. Click *Create*.
7. Click the play button at the top of project navigator.

If you've set it up correctly, you should see this in the debug window:

	…SmartFactoryLogger[95797:303] Hello, World!
	Program ended with exit code: 0

### 2. Primitives ###

Use `NSLog` to print some values to the console.

Replace the "Hello, World!" line with the following:

	NSLog(@"I ate %d cookies.", 10);
	NSLog(@"I ate %f pies.", 3.14529);
	
Click play to run and you should see something like this in the debug window:

	…SmartFactoryLogger[95932:303] I ate 10 cookies
	…SmartFactoryLogger[95932:303] I ate 3.145900 pies
	Program ended with exit code: 0

Wow, you must have been hungry!

`NSLog` is a handy C utility that prints whatever you want to the console.  It works almost exactly like printf(1) except that it knows how to work with Objective-C objects.  Go ahead and play around with a few different C primitive values and [format specifiers](https://developer.apple.com/library/ios/documentation/cocoa/conceptual/Strings/Articles/formatSpecifiers.html).  Does it get more exciting than this?

### 3. Arrays ###

Below your previous log statements, declare a few `NSString *` variables and give them some string literals as values:

	NSString *camembert = @"Camembert";
	NSString *gouda = @"Gouda";
	NSString *cheddar = @"Cheddar";

Just like in C, `NSString *camembert` declares a pointer to an object of type `NSString`.  Don't forget those `@` symbols!  Since the compiler also knows about C strings, the `@` symbol  is there to tell the compiler that we want an NSString literal, instead of a C string which is nothing more than a nil-terminated array of chars. We want real objects, because we're serious.  Also `NSLog` takes an NSString as its first argument, not a C string.

Now, create an `NSArray` to hold your objects like so:
	
	NSArray *cheeses = [[NSArray alloc] initWithObjects:camembert, gouda, cheddar, nil];

Here we see the good old fashioned alloc/init one two punch, the standard object creation pattern in Objective-C.  Remember, our `NSString` declarations above are conceptually doing the same thing under the covers.  The `@` is just compiler sugar that makes our code pretty.  Notice that the `initWithObjects:` method we're using takes variadic arguments, with `nil` indicating the end of the arguments list.

Okay, try looping over the array you just created and use `NSLog` to print each one to the console the old-fashioned way:

	for (int i = 0; i < cheeses.count; i++)
    {
    	NSString *cheese = [cheeses objectAtIndex:i];
        NSLog(@"A kind of cheese is %@", cheese);
    }
	
Run this and you should see something like:
	
	…SmartFactoryLogger[95932:303] A kind of cheese is Camembert
	…SmartFactoryLogger[95932:303] A kind of cheese is Gouda
	…SmartFactoryLogger[95932:303] A kind of cheese is Cheddar
	Program ended with exit code: 0
	
In case you hadn't tried it earlier, you'll notice that `%@` is the format specifier that prints out an object.  Let's see printf do that!

Classic C for loops are great and all, but let's give fast-iteration a spin.  Update your for-loop so it looks like this:

	for (NSString *cheese in cheeses)
	{
		NSLog(@"A kind of cheese is %@", cheese)
	}
	

Run it again an you'll see the same result, but much faster.  What, you couldn't tell the difference?  Well, at least the code is cleaner.

Out of curiosity, let's see what happens if you forget to initialize one of the cheeses:

	// Replace this line
	NSString *gouda = @"Gouda";
	
	// With this line
	NSString *gouda;
	
Make this change and run it to see for yourself.  

	…SmartFactoryLogger[95932:303] A kind of cheese is Camembert
	Program ended with exit code: 0

Why is this happening?  Since `gouda` is nil, our `initWithObjects` thinks the argument list ends with `camembert`.  No compiler error, not even a warning or exception.

Before fixing it, let's just change the way we're creating the array.  Let's use literal syntax instead:

	// Replace
	NSArray *cheeses = [[NSArray alloc] initWithObjects:camembert, gouda, cheddar, nil];
	
	// With
	NSArray *cheeses = @[camembert, gouda, cheddar];
	
Now run.

	*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]'

Boom.  Exception.  It turns out that NSArrays (and collections in general) don't like it when we try to  store `nil`.

Side note: If you haven't hit the stop button yet, your program is now stopped in the debugger.  In your console you should see a little prompt that looks like:
	
	(lldb)
	
This is a REPL of sorts and let's us interact with the objects in memory at the time when the exception occurred.

Type this at the prompt:

	(lldb) po cheddar
	Cheddar

Neat eh?  `po` is short for print object.  File that away under your useful debugging tools. Now, hit stop and let's try again.

The following is a terrible idea, but one thing we could do is catch the exception.  Give this a try:

	@try 
	{
		NSArray *cheeses = @[camembert, gouda, cheddar];
		for (NSString *cheese in cheeses)
		{
			NSLog(@"A kind of cheese is %@", cheese);
		}
	} 
	@catch (NSException *exception) 
	{
		NSLog(@"An exception was thrown, but it was ignored");
	}

No more crashing.  Ship it!  Okay, probably not, but let's say we did want to store something that represents nothing.  One option is an empty string `@""`, another is `NSNull`.  Take out the try/catch blocks and initilize gouda like so:

	NSString *gouda = [NSNull null];
	
Now you'll see a compiler warning, saying that the pointer types are incompatible.  Ignore this for now.  

Run again, and you will see:

	…SmartFactoryLogger[95932:303] A kind of cheese is Camembert
	…SmartFactoryLogger[95932:303] A kind of cheese is <null>
	…SmartFactoryLogger[95932:303] A kind of cheese is Cheddar
	Program ended with exit code: 0

### 4. Dictionaries ###

Try creating a dictionary with a factory method:

    NSDictionary *stateCapitals = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"Saint Paul", @"Minnesota",
                                       @"Des Moines", @"Iowa",
                                       @"Milwaukee", @"Wisconsin", nil];
        
											    
Loop over your dictionary and log out its keys and values

    for (NSString *state in stateCapitals)
    {
        NSLog(@"The capital of %@ is %@", state, [stateCapitals objectForKey:state]);
    }
    
You can retrieve all the keys or all the values like so:
	
	NSArray *states = [stateCapitals allKeys];
	NSLog(@"just states = %@", states);
	
	NSArray *capitals = [stateCapitals allValues];
	NSLog(@"just capitals = %@", capitals);

You might notice that the order of the keys and values are different than how you added them originally.  

1. Change the dictionary creation to use the literal syntax.
2. Change the NSLog statement inside the for loop to use subscripting.
3. Try nesting a dictionary within another and use subscripting to access a value in the nested dictionary.
4. Use `valueForKeyPath:` to retrieve the same value.  See [this](https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/KeyValueCoding/Articles/CollectionOperators.html#//apple_ref/doc/uid/20002176-SW6) for relevant documentation.

### 5. Mutability ###

Create a mutable set and add a few objects

	NSMutableSet *breweries = [NSMutableSet setWithCapacity:3];

    [breweries addObject:@"Fulton"];
	[breweries addObject:@"Surly"];
	[breweries addObject:@"Indeed"];

	NSLog(@"A set of breweries %@", breweries);

1. Create a local string variable, assigning it to "Indeed".  Add this string to the set.  Log the resulting set.
2. Remove "Surly" from the set.  Log the resulting set.

### 6. Equality ###

Log some expressions using equality

   	NSString *firstString = @"wat";
   	NSString *secondString = @"wat";

   	NSMutableString *thirdString = [[NSMutableString alloc] init];
   	[thirdString appendString:@"wat"];
   
   	NSLog(@"==: %d", firstString == secondString);
   	NSLog(@"isEqual: %d", [firstString isEqual:secondString]);

   	NSLog(@"==: %d", secondString == thirdString);
   	NSLog(@"isEqual: %d", [secondString isEqual:thirdString]);
   	
1. Try comparing NSNumbers similarly, using isEqual.
2. Try comparing some collections using isEqual.







