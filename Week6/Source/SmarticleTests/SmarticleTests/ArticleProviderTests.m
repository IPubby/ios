//
//  ArticleProviderTests.m
//  Smarticle
//
//  Created by Adam May on 6/22/14.
//  Copyright (c) 2014 Smart Factory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "OHHTTPStubs.h"
#import "ArticleProvider.h"

@interface ArticleProviderTests : XCTestCase

@property (nonatomic, strong) ArticleProvider *unitUnderTest;
@property (nonatomic, strong) id delegateMock;

@end

@implementation ArticleProviderTests

- (void)setUp
{
    [super setUp];
    
    self.unitUnderTest = [[ArticleProvider alloc] initWithArticleType:ArticleTypeMostViewed];
    
    OCMockObject *delegate = [OCMockObject mockForProtocol:@protocol(ArticleProviderDelegate)];
    self.delegateMock = delegate;
    
    self.unitUnderTest.delegate = self.delegateMock;
}

- (void)tearDown
{
    [OHHTTPStubs removeAllStubs];
    
    [self.delegateMock stopMocking];
    self.delegateMock = nil;
    
    self.unitUnderTest = nil;

    [super tearDown];
}

- (void)stubArticleRequestWithSuccessfulResponse
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSURL *articlesURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"articles" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:articlesURL];
        
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];
}

- (void)stubArticleRequestWithErrorResponse
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:@"FakeErrorDomain" code:1 userInfo:nil]];
    }];
}

- (void)stubArticleRequestWithErrorCodeResponse
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:nil statusCode:400 headers:nil];
    }];
}

- (void)stubArticleRequestWithInvalidJSONResponse
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:200 headers:nil];
    }];
}

- (void)waitUntilProviderFinishesLoading
{
    while ([self.unitUnderTest isLoading])
    {
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }
}

- (void)testReloadWithSuccessCallsDidLoadDataAtIndexes
{
    [self stubArticleRequestWithSuccessfulResponse];
    
    NSIndexSet *articleIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)];
    [[self.delegateMock expect] provider:self.unitUnderTest didLoadDataAtIndexes:articleIndexes];
    
    [self.unitUnderTest reload];
    [self waitUntilProviderFinishesLoading];
    
    [self.delegateMock verify];
}

- (void)testReloadWithErrorCallsDidFailWithError
{
    [self stubArticleRequestWithErrorResponse];
    
    [[self.delegateMock expect] provider:self.unitUnderTest didFailWithError:OCMOCK_ANY];
    
    [self.unitUnderTest reload];
    [self waitUntilProviderFinishesLoading];
    
    [self.delegateMock verify];
}

- (void)testReloadWithResponseErrorCallsDidFailWithError
{
    [self stubArticleRequestWithErrorCodeResponse];
    
    [[self.delegateMock expect] provider:self.unitUnderTest didFailWithError:OCMOCK_ANY];
    
    [self.unitUnderTest reload];
    [self waitUntilProviderFinishesLoading];
    
    [self.delegateMock verify];
}

- (void)testReloadWithInvalidJSONCallsDidFailWithError
{
    [self stubArticleRequestWithInvalidJSONResponse];
    
    [[self.delegateMock expect] provider:self.unitUnderTest didFailWithError:OCMOCK_ANY];

    [self.unitUnderTest reload];
    [self waitUntilProviderFinishesLoading];
    
    [self.delegateMock verify];
}

- (void)testHasMoreArticles
{
    XCTAssertFalse([self.unitUnderTest hasMoreArticles], @"Should not have more articles before reload.");
    
    [self stubArticleRequestWithSuccessfulResponse];

    [[self.delegateMock stub] provider:self.unitUnderTest didLoadDataAtIndexes:OCMOCK_ANY];
    
    [self.unitUnderTest reload];
    [self waitUntilProviderFinishesLoading];
    
    XCTAssertTrue([self.unitUnderTest hasMoreArticles], @"Should have more articles after loading.");
}

- (void)testLoadMoreArticles
{
    [self stubArticleRequestWithSuccessfulResponse];
    
    NSIndexSet *articleIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)];
    [[self.delegateMock expect] provider:self.unitUnderTest didLoadDataAtIndexes:articleIndexes];
    
    [self.unitUnderTest reload];
    [self waitUntilProviderFinishesLoading];
    
    articleIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(20, 20)];
    [[self.delegateMock expect] provider:self.unitUnderTest didLoadDataAtIndexes:articleIndexes];
    
    [self.unitUnderTest loadMoreArticles];
    [self waitUntilProviderFinishesLoading];
    
    [self.delegateMock verify];
}

@end
