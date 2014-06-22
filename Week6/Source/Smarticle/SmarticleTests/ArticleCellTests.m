//
//  ArticleCellTests.m
//  Smarticle
//
//  Created by Adam May on 12/15/13.
//  Copyright (c) 2013 Smart Factory. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Article.h"
#import "ArticleCell.h"
#import "ListViewController.h"

@interface ArticleCellTests : XCTestCase

@property (nonatomic, strong) ArticleCell *cell;

@end

@implementation ArticleCellTests

- (void)setUp
{
    [super setUp];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListViewController *list = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    self.cell = [list.tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testOutletConnections
{
    XCTAssertNotNil([self.cell valueForKey:@"abstractLabel"], @"Abstract label should be non-nil.");
    XCTAssertNotNil([self.cell valueForKey:@"favoriteLabel"], @"Abstract label should be non-nil.");
    XCTAssertNotNil([self.cell valueForKey:@"titleLabel"], @"Abstract label should be non-nil.");
}

- (void)testSetArticle
{
    Article *article = [[Article alloc] init];
    article.title = @"Bob Loblaw Launches Law Blog";
    article.abstract = @"You don't say!";
    [self.cell setArticle:article];
    
    XCTAssertEqualObjects([[self.cell valueForKey:@"titleLabel"] text], @"Bob Loblaw Launches Law Blog", @"Should have set title label text");
    XCTAssertEqualObjects([[self.cell valueForKey:@"abstractLabel"] text], @"You don't say!", @"Should have set abstract label text");
}

@end
