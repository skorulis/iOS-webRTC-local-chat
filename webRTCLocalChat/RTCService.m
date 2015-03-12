//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.


#import "RTCService.h"
#import <RTCMediaConstraints.h>
#import <RTCPair.h>

#import <RTCDataChannel.h>

@interface RTCService () {
    RTCPeerConnectionFactory* _factory;
}

@end

@implementation RTCService

- (instancetype) init {
    self = [super init];
    [RTCPeerConnectionFactory initializeSSL];
    _factory = [[RTCPeerConnectionFactory alloc] init];
    return self;
}

- (RTCConnectionWrapper*) getConnection {
    RTCPair* pair = [[RTCPair alloc] initWithKey:@"DtlsSrtpKeyAgreement" value:@"true"];
    RTCMediaConstraints* constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil optionalConstraints:@[pair]];
    RTCConnectionWrapper* wrapper = [[RTCConnectionWrapper alloc] init];
    wrapper.peerConnection = [_factory peerConnectionWithICEServers:nil constraints:constraints delegate:wrapper];
    return wrapper;
}

@end
