#import <Foundation/Foundation.h>

/// The article object represents a popular article from the NY Times.
///
@interface Article : NSObject

#pragma mark - Properties

/// Brief summary of the article.
///
@property (nonatomic, copy) NSString *abstract;

/// Byline that includes the author's name.
///
@property (nonatomic, copy) NSString *byline;

/// The NY Times ID for the article.
///
@property (nonatomic, copy) NSString *remoteId;

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

/// Returns a set of demo articles for testing. This array will be replaced by downloading the
/// articles via the network.
///
+ (NSArray *)demoArticles;

@end
