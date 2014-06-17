#import <Foundation/Foundation.h>
#import "ArticleImage.h"

/// The article object represents a popular article from the NY Times.
///
@interface Article : NSObject <NSCoding>

#pragma mark - Properties

/// Brief summary of the article.
///
@property (nonatomic, copy) NSString *abstract;

/// Byline that includes the author's name.
///
@property (nonatomic, copy) NSString *byline;

/// Image to display by default. Usually high enough resolution to look good on retina but not super
/// huge.
///
@property (nonatomic, strong) ArticleImage *defaultImage;

/// An array of images associated with this article. Images are ArticleImage objects.
///
@property (nonatomic, strong) NSArray *images;

/// Indicates whether or not this article is a favorite.
///
@property (nonatomic, assign) BOOL isFavorite;

/// The date that the article was published. Note that we're not creating an NSDate object for
/// simplicity.
///
@property (nonatomic, copy) NSString *publishedDate;

/// The section of news that the article belongs to. e.g. Sports.
///
@property (nonatomic, copy) NSString *section;

/// The source of the article. e.g. NY Times.
///
@property (nonatomic, copy) NSString *source;

/// The title of the article.
///
@property (nonatomic, copy) NSString *title;

/// The URL for the full article on the NY Times web site.
///
@property (nonatomic, copy) NSString *url;

#pragma mark - Class Methods

+ (NSArray *)articlesForJSON:(id)json;

@end
