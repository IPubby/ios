#import "ArticleImage.h"

@implementation ArticleImage

+ (ArticleImage *)imageForDictionary:(NSDictionary *)imageDictionary
{
    ArticleImage *image = [[ArticleImage alloc] init];
    
    image.height = [imageDictionary[@"height"] integerValue];
    image.url = imageDictionary[@"url"];
    image.width = [imageDictionary[@"width"] integerValue];
    
    return image;
}

#pragma mark - NSCopying

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _caption = [aDecoder decodeObjectForKey:@"caption"];
        _height = [aDecoder decodeIntegerForKey:@"height"];
        _url = [aDecoder decodeObjectForKey:@"url"];
        _width = [aDecoder decodeIntegerForKey:@"width"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.caption forKey:@"caption"];
    [aCoder encodeInteger:self.height forKey:@"height"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInteger:self.width forKey:@"width"];
}

@end
