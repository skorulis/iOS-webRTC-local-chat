//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import UIKit;
#import "RTCService.h"
#import "RTCConnectionWrapper.h"

@interface ChatWindowViewController : UIViewController

@property (nonatomic, readonly) RTCConnectionWrapper* peerConnection;

- (instancetype) initWithService:(RTCService*)service name:(NSString*)name;

@end
