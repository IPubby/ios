#import "Article.h"

@implementation Article

+ (NSArray *)articlesForJSON:(NSArray *)resultsArray
{
    NSMutableArray *mutableArticles = [[NSMutableArray alloc] initWithCapacity:resultsArray.count];
    
    for (NSDictionary *resultsDictionary in resultsArray)
    {
        Article *article = [self articleForDictionary:resultsDictionary];
        [mutableArticles addObject:article];
    }
    
    return [NSArray arrayWithArray:mutableArticles];
}

+ (Article *)articleForDictionary:(NSDictionary *)resultsDictionary
{
    Article *article = [[Article alloc] init];
    
    article.abstract = resultsDictionary[@"abstract"];
    article.byline = resultsDictionary[@"byline"];
    article.publishedDate = resultsDictionary[@"published_date"];
    article.section = resultsDictionary[@"section"];
    article.source = resultsDictionary[@"source"];
    article.title = resultsDictionary[@"title"];
    article.url = resultsDictionary[@"url"];
    
    NSArray *media = resultsDictionary[@"media"];
    
    if ([media isKindOfClass:[NSArray class]] == YES)
    {
        NSMutableArray *images = [NSMutableArray array];
        
        for (NSDictionary *mediumDictionary in media)
        {
            if ([mediumDictionary[@"type"] isEqualToString:@"image"] == YES)
            {
                NSArray *metadata = mediumDictionary[@"media-metadata"];
                
                for (NSDictionary *imageDictionary in metadata)
                {
                    ArticleImage *image = [ArticleImage imageForDictionary:imageDictionary];

                    image.caption = mediumDictionary[@"caption"];
                    
                    [images addObject:image];
                }
            }
        }
        
        article.images = images;
    }
    
    return article;
}

- (ArticleImage *)defaultImage
{
    ArticleImage *defaultImage = [[ArticleImage alloc] init];
    defaultImage.width = 0;
    defaultImage.height = 0;

    for (ArticleImage *image in self.images)
    {
        NSRange urlSuffixRange = [image.url rangeOfString:@"thumbStandard"];
        
        if (urlSuffixRange.location != NSNotFound)
        {
            // This is a bit of a hack to grab a high-res image for the detail view.
            // Via trial and error, we noticed that not all of the data returned by
            // the NY Times web service doesn't include good quality images even
            // though the articles on their web site do. Fortunately for us there's
            // a pattern to the URL names that we can abuse:
            //
            // - Every article from the web service includes an image URL that
            //   contains a "thumbStandard*.png" suffix.
            //
            // - We can trim off the "thumbStandard" text and append
            //   "tmagArticle.jpg" to get a reference to the actual image used on
            //   nytimes.com for the article.
            //
            // For example, this original image URL:
            //
            //   http://graphics8.nytimes.com/images/2013/11/26/world/25DIPLO/25DIPLO-thumbStandard.jpg
            //
            // Becomes:
            //
            //   http://graphics8.nytimes.com/images/2013/11/26/world/25DIPLO/25DIPLO-tmagArticle.jpg
            //
            // It doesn't always work, but it works often enough.
            
            NSRange urlPrefixRange = NSMakeRange(0, urlSuffixRange.location);
            NSString *urlPrefix = [image.url substringWithRange:urlPrefixRange];
            defaultImage.url = [urlPrefix stringByAppendingString:@"tmagArticle.jpg"];
        }
    }
    
    return defaultImage;
}

#pragma mark - NSCopying

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _abstract = [aDecoder decodeObjectForKey:@"abstract"];
        _byline = [aDecoder decodeObjectForKey:@"byline"];
        _defaultImage = [aDecoder decodeObjectForKey:@"defaultImage"];
        _images = [aDecoder decodeObjectForKey:@"images"];
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
    [aCoder encodeObject:self.defaultImage forKey:@"defaultImage"];
    [aCoder encodeObject:self.images forKey:@"images"];
    [aCoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [aCoder encodeObject:self.section forKey:@"section"];
    [aCoder encodeObject:self.source forKey:@"source"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeBool:self.isFavorite forKey:@"isFavorite"];
}

@end