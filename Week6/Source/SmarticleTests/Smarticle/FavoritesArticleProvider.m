#import "FavoritesArticleProvider.h"
#import "ArticlesController.h"

@implementation FavoritesArticleProvider

- (id)init
{
    self = [super initWithArticleType:ArticleTypeFavorites];
    
    return self;
}

- (NSUInteger)count
{
    return [[ArticlesController sharedInstance] favoriteArticles].count;
}

- (Article *)articleAtIndex:(NSUInteger)index
{
    return [[[ArticlesController sharedInstance] favoriteArticles] objectAtIndex:index];
}

- (BOOL)hasMoreArticles
{
    return NO;
}

- (NSUInteger)numberOfArticles
{
    return [[ArticlesController sharedInstance] favoriteArticles].count;
}

- (void)reload
{
    if ([self.delegate respondsToSelector:@selector(provider:didLoadDataAtIndexes:)])
    {
        [self.delegate provider:self didLoadDataAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.count)]];
    }
}

@end
