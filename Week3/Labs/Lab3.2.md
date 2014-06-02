## Lab 3.2: NSKeyedArchiver

### Objectives

- Enable marking articles as favorites
- Use `NSKeyedArchiver` to write data to disk
- Load cached data from disk on startup

### Additional Resources

- [NSCoding/NSKeyedArchiver](http://nshipster.com/nscoding/)
- [Archives and Serializations Programming Guide](https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/Archiving/Archiving.html#//apple_ref/doc/uid/10000047i)

### Development Setup

1. Clone the GitHub repository: `git@github.com:gosmartfactory/ios.git`
2. Browse to the following directory: `Week3/Source/SmarticleLab3.2`
3. Open the app in Xcode by double-clicking the project file: `Smarticle`
4. Run the app in the simulator by clicking on the Play icon or click on `Product -> Run`

### Implement the following methods in `ArticlesController.m`

```objective-c
- (void)addFavoriteArticle:(Article *)article;
- (void)removeFavoriteArticle:(Article *)article;
- (NSArray *)readFavoriteArticles;
- (void)writeFavoriteArticles;
```

### `addFavoriteArticle:`

This method is responsible for doing the following:

* Set the `isFavorite` property for this article to `YES` to mark this article as a favorite.
* Add this article to an `NSArray` of favorites.
* Save the updated favorites list to disk.

The first step is pretty simple. We're updating this article to mark it as a favorite.

```objective-c
article.isFavorite = YES;
```

Next up, we add this article to an array.

```objective-c
[self.favorites addObject:article];
```

And finally, we'll invoke another new method called `writeFavoriteArticles` (that we haven't written yet) to save the new favorites list to disk. Don't worry about the implementation of this method quite yet.

```objective-c
[self writeFavoriteArticles];
```

### `removeFavoriteArticle:`

This method does pretty much the reverse of the method above. Here's the breakdown:

* Set the `isFavorite` property for this article ot `NO`.
* Retreive the article from our existing favorites list based on its `url` property. We're using `url` as a key to identify this article.
* If you find the article in the existing favorites list:
    * Remove it from the list.
    * Save the updated favorites list to disk.

**Hint:** You can look up an article based on its `url` in an `NSArray` with a helper method that we wrote for you called `favoriteArticleWithURLString:`.

```objective-c
Article *favorite = [self favoriteArticleWithURLString:article.url];
```

### `readFavoriteArticles`

This method loads the favorite articles from disk. If this is the first time the app has been run, then there won't be a file on disk, and our favorites list will be `nil`. No prob! This method is invoked in `ArticlesController`'s init method.

```objective-c
return [NSKeyedUnarchiver unarchiveObjectWithFile:[self favoritesFilePath]];
```

### `writeFavoriteArticles`

This method writes the favorites to disk. This method is invoked manually whenever the favorites list is change. In our case, that means this method is invoked by the `addFavoriteArticle:` and `removeFavoriteArticle:` methods.

```objective-c
[NSKeyedArchiver archiveRootObject:self.favorites toFile:[self favoritesFilePath]];
```

### Loading Favorites on Start Up

The last piece of the puzzle is to load our favorites from disk (if there are any) when the ArticlesController is initialized.

We can do that by updating the `init` method to call `readFavoriteArticles` and assign the result to our `_favorites` ivar.

### Next Steps

* Read and write the keyed archive on a background thread to prevent `readFavoriteArticles` and `writeFavoriteArticles` from blocking the main thread.
