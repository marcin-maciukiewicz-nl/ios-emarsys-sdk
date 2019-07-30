//
//  Copyright © 2019 Emarsys. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EMSLogic.h"
#import "EMSCartItem.h"

@interface EMSLogicTests : XCTestCase

@end

@implementation EMSLogicTests

- (void)testSearch {
    EMSLogic *logic = EMSLogic.search;

    XCTAssertEqualObjects(logic.logic, @"SEARCH");
}

- (void)testSearchWithSearchTerm_when_searchTermIsNotNil {
    EMSLogic *logic = [EMSLogic searchWithSearchTerm:@"searchTerm"];

    XCTAssertEqualObjects(logic.logic, @"SEARCH");
    XCTAssertEqualObjects(logic.data, @{@"q": @"searchTerm"});
}

- (void)testSearchWithSearchTerm_when_searchTermIsNil {
    EMSLogic *logic = [EMSLogic searchWithSearchTerm:nil];

    XCTAssertEqualObjects(logic.logic, @"SEARCH");
    XCTAssertEqualObjects(logic.data, @{@"q": @""});
}

- (void)testCart {
    EMSLogic *logic = EMSLogic.cart;

    XCTAssertEqualObjects(logic.logic, @"CART");
}

- (void)testCartWithCartItems_when_cartItemsAreNotNil {
    EMSCartItem *cartItem1 = [[EMSCartItem alloc] initWithItemId:@"cartItemId1"
                                                           price:123
                                                        quantity:1];
    EMSCartItem *cartItem2 = [[EMSCartItem alloc] initWithItemId:@"cartItemId2"
                                                           price:456
                                                        quantity:2];
    NSDictionary *expectedData = @{
        @"cv": @"1",
        @"ca": @"i:cartItemId1,p:123.0,q:1.0|i:cartItemId2,p:456.0,q:2.0"
    };

    EMSLogic *logic = [EMSLogic cartWithCartItems:@[cartItem1, cartItem2]];

    XCTAssertEqualObjects(logic.logic, @"CART");
    XCTAssertEqualObjects(logic.data, expectedData);
}

- (void)testCartWithCartItems_when_cartItemsAreNil {
    NSDictionary *expectedData = @{
        @"cv": @"1",
        @"ca": @""
    };

    EMSLogic *logic = [EMSLogic cartWithCartItems:nil];

    XCTAssertEqualObjects(logic.logic, @"CART");
    XCTAssertEqualObjects(logic.data, expectedData);
}

- (void)testRelated {
    EMSLogic *logic = EMSLogic.related;

    XCTAssertEqualObjects(logic.logic, @"RELATED");
}

- (void)testRelatedWithViewItemId_when_ViewItemIdIsNotNil {
    EMSLogic *logic = [EMSLogic relatedWithViewItemId:@"testItemId"];

    XCTAssertEqualObjects(logic.logic, @"RELATED");
    XCTAssertEqualObjects(logic.data, @{@"v": @"i:testItemId"});
}

- (void)testRelatedWithViewItemId_when_ViewItemIdIsNil {
    EMSLogic *logic = [EMSLogic relatedWithViewItemId:nil];

    XCTAssertEqualObjects(logic.logic, @"RELATED");
    XCTAssertEqualObjects(logic.data, @{@"v": @""});
}

@end