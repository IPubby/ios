#import "Article.h"

@implementation Article

+ (NSArray *)articlesForJSON:(id)json
{
    NSArray *resultsArray = json[@"results"];
    
    NSMutableArray *mutableArticles = [[NSMutableArray alloc] initWithCapacity:resultsArray.count];
    
    for (NSDictionary *resultsDictionary in resultsArray)
    {
        Article *article = [[Article alloc] init];
        
        article.abstract = resultsDictionary[@"abstract"];
        article.byline = resultsDictionary[@"byline"];
        article.publishedDate = resultsDictionary[@"published_date"];
        article.section = resultsDictionary[@"section"];
        article.source = resultsDictionary[@"source"];
        article.title = resultsDictionary[@"title"];
        article.url = resultsDictionary[@"url"];
        
        [mutableArticles addObject:article];
    }
    
    return [NSArray arrayWithArray:mutableArticles];
}

#pragma mark - NSCopying

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _abstract = [aDecoder decodeObjectForKey:@"abstract"];
        _byline = [aDecoder decodeObjectForKey:@"byline"];
        _publishedDate = [aDecoder decodeObjectForKey:@"publishedDate"];
        _section = [aDecoder decodeObjectForKey:@"section"];
        _source = [aDecoder decodeObjectForKey:@"source"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _url = [aDecoder decodeObjectForKey:@"url"];
        _isFavorite = [aDecoder decodeBoolForKey:@"isFavorite"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.abstract forKey:@"abstract"];
    [aCoder encodeObject:self.byline forKey:@"byline"];
    [aCoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [aCoder encodeObject:self.section forKey:@"section"];
    [aCoder encodeObject:self.source forKey:@"source"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeBool:self.isFavorite forKey:@"isFavorite"];
}

@end