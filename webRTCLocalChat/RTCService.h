//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import <RTCPeerConnectionFactory.h>

@interface RTCService : NSObject

- (RTCPeerConnection*) getConnection:(id<RTCPeerConnectionDelegate>)delegate;

@end
