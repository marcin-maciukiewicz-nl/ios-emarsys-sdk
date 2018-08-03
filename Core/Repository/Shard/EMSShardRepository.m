//
// Copyright (c) 2018 Emarsys. All rights reserved.
//
#import "EMSShardRepository.h"
#import "EMSSQLiteHelper.h"
#import "EMSShardMapper.h"
#import "EMSSchemaContract.h"
#import "EMSCountMapper.h"

@interface EMSShardRepository ()

@property(nonatomic, strong) EMSSQLiteHelper *dbHelper;
@property(nonatomic, strong) EMSShardMapper *mapper;

@end

@implementation EMSShardRepository

- (instancetype)initWithDbHelper:(EMSSQLiteHelper *)sqliteHelper {
    if (self = [super init]) {
        _dbHelper = sqliteHelper;
        _mapper = [EMSShardMapper new];
        _dbHelper = sqliteHelper;
        [_dbHelper open];
    }
    return self;
}

- (void)add:(EMSShard *)item {
    NSParameterAssert(item);
    [self.dbHelper insertModel:item
                     withQuery:SQL_SHARD_INSERT
                        mapper:self.mapper];
}

- (void)remove:(id <EMSSQLSpecificationProtocol>)sqlSpecification {
    [self.dbHelper executeCommand:sqlSpecification.sql];
}

- (NSArray<EMSShard *> *)query:(id <EMSSQLSpecificationProtocol>)sqlSpecification {
    NSArray *result = [self.dbHelper executeQuery:sqlSpecification.sql
                                           mapper:self.mapper];
    if (!result) {
        result = @[];
    }

    return result;
}

- (BOOL)isEmpty {
    NSNumber *count = [[self.dbHelper executeQuery:SQL_SHARD_COUNT mapper:[EMSCountMapper new]] firstObject];
    return [count integerValue] == 0;
}

@end