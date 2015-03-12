//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "ChatWindowViewController.h"
#import <Masonry/Masonry.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "UIViewController+KeyboardAnimation.h"
#import <RTCPeerConnectionDelegate.h>


@interface ChatWindowViewController () <RTCPeerConnectionDelegate> {
    NSString* _windowName;
    UILabel* _titleLabel;
    UITextView* _chatText;
    UIButton* _sendButton;
    RTCService* _service;
    RTCPeerConnection* _peerConnection;
}

@property (nonatomic, readonly) MASConstraint* entryBottomConstraint;
@property (nonatomic, readonly) UITextView* entryText;

@end

@implementation ChatWindowViewController

- (instancetype) initWithService:(RTCService*)service name:(NSString*)name {
    self = [super init];
    self.title = name;
    _windowName = name;
    _service = service;
    _peerConnection = [_service getConnection:self];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _windowName;
    _titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    _chatText = [[UITextView alloc] init];
    _chatText.editable = false;
    _chatText.backgroundColor = [UIColor grayColor];
    
    _sendButton = [[UIButton alloc] init];
    FAKIcon* icon = [FAKFontAwesome sendIconWithSize:30];
    [_sendButton setAttributedTitle:icon.attributedString forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _entryText = [[UITextView alloc] init];
    _entryText.editable = true;
    _entryText.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_chatText];
    [self.view addSubview:_entryText];
    [self.view addSubview:_sendButton];
    
    [self buildLayout];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        CGFloat showingOffset = -CGRectGetHeight(keyboardRect);
        weakSelf.entryBottomConstraint.offset = isShowing ? showingOffset  : -50;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
}

- (void) buildLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(30);
    }];
    
    [_chatText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
    }];
    
    [_entryText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chatText.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(_sendButton.mas_left);
        make.height.equalTo(@80);
        _entryBottomConstraint = make.bottom.equalTo(self.view).with.offset(-50);
    }];
    
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.bottom.equalTo(_entryText);
        make.height.equalTo(_sendButton.mas_width);
    }];
}

#pragma mark actions

- (void) sendPressed:(id)sender {
    NSString* toSend = _entryText.text;
    if(toSend.length == 0) {
        return;
    }
    _chatText.text = [NSString stringWithFormat:@"%@%@:%@\n",_chatText.text,self.title,toSend];
    _entryText.text = nil;
    
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
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection didOpenDataChannel:(RTCDataChannel*)dataChannel {
    NSLog(@"Did open channel %@",dataChannel);
}

@end
