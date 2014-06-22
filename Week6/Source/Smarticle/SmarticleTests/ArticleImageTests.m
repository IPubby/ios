//
//  ArticleImageTests.m
//  Smarticle
//
//  Created by Adam May on 12/15/13.
//  Copyright (c) 2013 Smart Factory. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ArticleImage.h"

@interface ArticleImageTests : XCTestCase

@end

@implementation ArticleImageTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testImageForDictionary
{
    NSDictionary *dictionary = @{@"height": @90,
                                 @"width": @90,
                                 @"url": @"http://www.example.com/background.jpg"};
    
    ArticleImage *image = [ArticleImage imageForDictionary:dictionary];
    XCTAssertEqual(image.width, (NSInteger)90, @"Should have image width");
    XCTAssertEqual(image.height, (NSInteger)90, @"Should have image height");
    XCTAssertEqual(image.url, @"http://www.example.com/background.jpg", @"Should have url");
}

- (void)testInitWithCoder
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    [archiver encodeObject:@"test caption" forKey:@"caption"];
    [archiver encodeObject:@"http://www.example.com" forKey:@"url"];
    [archiver encodeInteger:50 forKey:@"width"];
    [archiver encodeInteger:45 forKey:@"height"];


    [archiver finishEncoding];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    ArticleImage *image = [[ArticleImage alloc] initWithCoder:unarchiver];
    
    XCTAssertEqualObjects(image.caption, @"test caption", @"Should have decoded caption.");
    XCTAssertEqual(image.width, (NSInteger)50, @"Should have decoded width.");
    XCTAssertEqual(image.height, (NSInteger)45, @"Should have decoded height.");
    XCTAssertEqualObjects(image.url, @"http://www.example.com", @"Should have decoded url");
}

- (void)testEncodeWithCoder
{
    ArticleImage *image = [[ArticleImage alloc] init];
    image.url = @"http://www.example.com";
    image.width = 42;
    image.height = 43;
    image.caption = @"test caption";
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    [image encodeWithCoder:archiver];
    
    [archiver finishEncoding];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    XCTAssertEqualObjects([unarchiver decodeObjectForKey:@"url"], @"http://www.example.com", @"Should have encoded url.");
    XCTAssertEqualObjects([unarchiver decodeObjectForKey:@"caption"], @"test caption", @"Should have decoded caption.");
    XCTAssertEqual([unarchiver decodeIntegerForKey:@"width"], (NSInteger)42, @"Should have decoded width");
    XCTAssertEqual([unarchiver decodeIntegerForKey:@"height"], (NSInteger)43, @"Should have decoded height");
}

@end
