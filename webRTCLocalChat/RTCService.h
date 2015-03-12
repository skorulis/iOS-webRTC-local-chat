//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import <RTCPeerConnectionFactory.h>
#import "RTCConnectionWrapper.h"

@interface RTCService : NSObject

- (RTCConnectionWrapper*) getConnection;

@end
