//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "ChatWindowViewController.h"
#import <Masonry/Masonry.h>

@interface ChatWindowViewController () {
    NSString* _windowName;
    UILabel* _titleLabel;
    UITextView* _chatText;
    UITextView* _entryText;
}

@end

@implementation ChatWindowViewController

- (instancetype) initWithName:(NSString*)name {
    self = [super init];
    self.title = name;
    _windowName = name;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _windowName;
    _titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:_titleLabel];
    [self buildLayout];
}

- (void) buildLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(30);
    }];
}

@end
