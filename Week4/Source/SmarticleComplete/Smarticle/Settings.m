#import "Settings.h"

/// The shared singleton instance, initialized once on the first call to sharedInstance.
///
static Settings *SettingsSharedInstance;

@implementation Settings

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^
    {
        SettingsSharedInstance = [[Settings alloc] init];
    });

    return SettingsSharedInstance;
}

#pragma mark - Instance Methods

- (UIColor *)colorForArticleType:(ArticleType)articleType
{
    UIColor *color;

    switch (articleType)
    {
        case ArticleTypeFavorites:
            color = [UIColor colorWithRed:118/255.0 green:104/255.0 blue:140/255.0 alpha:1.0];
            break;

        case ArticleTypeMostEmailed:
            color = [UIColor colorWithRed:235/255.0 green:183/255.0 blue:99/255.0 alpha:1.0];
            break;

        case ArticleTypeMostShared:
            color = [UIColor colorWithRed:231/255.0 green:90/255.0 blue:70/255.0 alpha:1.0];
            break;

        case ArticleTypeMostViewed:
            color = [UIColor colorWithRed:93/255.0 green:159/255.0 blue:156/255.0 alpha:1.0];
            break;
    }

    return color;
}

@end
