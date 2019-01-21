//
// Copyright (c) 2019 Emarsys. All rights reserved.
//
#import "EMSLogMapper.h"
#import "EMSRequestModel.h"
#import "EMSShard.h"
#import "EMSDeviceInfo.h"

@interface EMSLogMapper ()
@property(nonatomic, strong) MERequestContext *requestContext;
@end

@implementation EMSLogMapper

- (instancetype)initWithRequestContext:(MERequestContext *)requestContext {
    NSParameterAssert(requestContext);
    if (self = [super init]) {
        _requestContext = requestContext;
    }
    return self;
}

- (EMSRequestModel *)requestFromShards:(NSArray<EMSShard *> *)shards {
    NSParameterAssert(shards);
    NSParameterAssert([shards count] > 0);
    __weak typeof(self) weakSelf = self;
    return [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
            NSMutableArray<NSDictionary<NSString *, id> *> *logs = [NSMutableArray new];
            EMSDeviceInfo *deviceInfo = weakSelf.requestContext.deviceInfo;
            for (EMSShard *shard in shards) {
                NSMutableDictionary<NSString *, id> *shardData = [NSMutableDictionary dictionaryWithDictionary:shard.data];
                shardData[@"type"] = shard.type;
                shardData[@"device_info"] = @{
                    @"platform": deviceInfo.platform,
                    @"app_version": deviceInfo.applicationVersion,
                    @"sdk_version": deviceInfo.sdkVersion,
                    @"os_version": deviceInfo.osVersion,
                    @"model": deviceInfo.deviceModel,
                    @"hw_id": deviceInfo.hardwareId
                };
                [logs addObject:[NSDictionary dictionaryWithDictionary:shardData]];
            }
            [builder setUrl:@"https://ems-log-dealer.herokuapp.com/v1/log"];
            [builder setMethod:HTTPMethodPOST];
            [builder setPayload:@{@"logs": [NSArray arrayWithArray:logs]}];
        }
                          timestampProvider:self.requestContext.timestampProvider
                               uuidProvider:self.requestContext.uuidProvider];
}

@end