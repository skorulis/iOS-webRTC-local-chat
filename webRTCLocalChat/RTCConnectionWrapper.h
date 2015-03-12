//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import <RTCPeerConnection.h>
#import <RTCDataChannel.h>
#import <RTCPeerConnectionDelegate.h>
#import <RTCSessionDescriptionDelegate.h>

@class RTCConnectionWrapper;

@protocol RTCConnectionWrapperDelegate <NSObject>

- (void) rtcConnection:(RTCConnectionWrapper*)connection didCreateDataChannel:(RTCDataChannel*)dataChannel;

@end

@interface RTCConnectionWrapper : NSObject <RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate>

@property (nonatomic, weak) id<RTCConnectionWrapperDelegate> delegate;
@property (nonatomic, strong) RTCPeerConnection* peerConnection;
@property (nonatomic, readonly) RTCDataChannel* dataChannel;

- (void) connectTo:(RTCConnectionWrapper*)other;

@end
