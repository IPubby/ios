//
//  ArticlesControllerTests.m
//  Smarticle
//
//  Created by Adam May on 12/17/13.
//  Copyright (c) 2013 Smart Factory. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ArticlesController.h"
#import "OHHTTPStubs.h"

@interface ArticlesControllerTests : XCTestCase

@end

@implementation ArticlesControllerTests

- (void)setUp
{
    [super setUp];
    
    // Stub out all requests with some test json.
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSURL *articlesURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"articles" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:articlesURL];

        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];
}

- (void)tearDown
{
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testGetArticles
{
    ArticlesController *controller = [[ArticlesController alloc] init];
    
    __block NSArray *blockArticles;
    __block BOOL finished = NO;
    
    [controller getArticlesForArticleType:ArticleTypeMostEmailed
                                   offset:0
                        completionHandler:^(NSArray *articles,
                                            NSNumber *numberOfResults,
                                            NSError *error) {
        blockArticles = articles;

        finished = YES;
    }];
    
    // Wait a little while
    while (!finished) {
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:5];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }
    
    XCTAssertNotNil(blockArticles, @"Should have returned articles");
    XCTAssertEqual(blockArticles.count, (NSUInteger)20, @"Should have 20 articles");
    
}

@end
