//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "ChatWindowViewController.h"
#import <Masonry/Masonry.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "UIViewController+KeyboardAnimation.h"
#import <RTCDataChannel.h>


@interface ChatWindowViewController () < RTCDataChannelDelegate,RTCConnectionWrapperDelegate> {
    UILabel* _titleLabel;
    UITextView* _chatText;
    UIButton* _sendButton;
    RTCService* _service;
    RTCDataChannel* _dataChannel;
}

@property (nonatomic, readonly) MASConstraint* entryBottomConstraint;
@property (nonatomic, readonly) UITextView* entryText;

@end

@implementation ChatWindowViewController

- (instancetype) initWithService:(RTCService*)service name:(NSString*)name {
    self = [super init];
    self.title = name;
    _service = service;
    _peerConnection = [_service getConnection];
    _peerConnection.delegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = self.title;
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
    [self appendText:toSend name:self.title];
    _entryText.text = nil;
    NSData* data = [toSend dataUsingEncoding:NSUTF8StringEncoding];
    RTCDataBuffer* buffer = [[RTCDataBuffer alloc] initWithData:data isBinary:true];
    [_peerConnection.dataChannel sendData:buffer];
}

- (void) appendText:(NSString*)text name:(NSString*)name {
    _chatText.text = [NSString stringWithFormat:@"%@%@:%@\n",_chatText.text,name,text];
}

#pragma mark RTCConnectionWrapperDelegate

- (void) rtcConnection:(RTCConnectionWrapper*)connection didCreateDataChannel:(RTCDataChannel*)dataChannel {
    dataChannel.delegate = self;
}

#pragma mark RTCDataChannelDelegate

// Called when the data channel state has changed.
- (void)channelDidChangeState:(RTCDataChannel*)channel {
    NSLog(@"state change %@ %u",channel,channel.state);
    dispatch_async(dispatch_get_main_queue(), ^{
        if(channel.state == kRTCDataChannelStateOpen) {
            [self appendText:@"connected" name:@"system"];
        }
    });
}

// Called when a data buffer was successfully received.
- (void)channel:(RTCDataChannel*)channel didReceiveMessageWithBuffer:(RTCDataBuffer*)buffer {
    NSLog(@"Get buffer %@",buffer);
    NSString* s = [[NSString alloc] initWithData:buffer.data encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendText:s name:@"TEST"];
    });
}


@end
