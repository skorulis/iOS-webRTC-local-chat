//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "RTCConnectionWrapper.h"
#import <RTCSessionDescription.h>
#import <RTCICECandidate.h>

@interface RTCConnectionWrapper () {
    BOOL _didInitiate;
}

@property (nonatomic, weak) RTCConnectionWrapper* otherConnection;

@end

@implementation RTCConnectionWrapper

- (void) connectTo:(RTCConnectionWrapper*)other {
    NSParameterAssert(other);
    _didInitiate = true;
    _otherConnection = other;
    other.otherConnection = self;
    RTCDataChannelInit* config = [[RTCDataChannelInit alloc] init];
    config.isOrdered = false;
    _dataChannel = [_peerConnection createDataChannelWithLabel:@"sender" config:config];
    [_delegate rtcConnection:self didCreateDataChannel:_dataChannel];
    [_peerConnection createOfferWithDelegate:self constraints:nil];
}

#pragma mark RTCPeerConnectionDelegate

// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection signalingStateChanged:(RTCSignalingState)stateChanged {
    NSLog(@"State changed %u",stateChanged);
}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection addedStream:(RTCMediaStream *)stream {
    NSLog(@"Added stream %@",stream);
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection removedStream:(RTCMediaStream *)stream {
    NSLog(@"Removed stream %@",stream);
}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection {
    NSLog(@"Reneg needed %@",peerConnection);
}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection iceConnectionChanged:(RTCICEConnectionState)newState {
    NSLog(@"Ice connection changed %u",newState);
}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection iceGatheringChanged:(RTCICEGatheringState)newState {
    NSLog(@"ice gathering changed %u",newState);
}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection gotICECandidate:(RTCICECandidate *)candidate {
    NSLog(@"Got ice %@",candidate);
    if(candidate) {
        [_otherConnection.peerConnection addICECandidate:candidate];
    }
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection didOpenDataChannel:(RTCDataChannel*)dataChannel {
    NSLog(@"Did open channel %@",dataChannel);
    _dataChannel = dataChannel;
    [_delegate rtcConnection:self didCreateDataChannel:_dataChannel];
}

#pragma mark RTCSessionDescriptionDelegate

// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection didCreateSessionDescription:(RTCSessionDescription *)sdp error:(NSError *)error {
    NSLog(@"Created session description for %@",self);
    [_peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sdp];
    [_otherConnection.peerConnection setRemoteDescriptionWithDelegate:_otherConnection sessionDescription:sdp];
    if(_didInitiate) {
        [_otherConnection.peerConnection createAnswerWithDelegate:_otherConnection constraints:nil];
    }
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection didSetSessionDescriptionWithError:(NSError *)error {
    if(error) {
        NSLog(@"Error settings session description %@",error);
    }
}


@end
