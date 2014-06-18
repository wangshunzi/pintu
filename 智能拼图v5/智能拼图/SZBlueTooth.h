//
//  SZBlueTooth.h
//  智能拼图
//
//  Created by mac on 14-5-27.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SZSndData.h"
@class SZBlueTooth;
@protocol SZBlueToothDelegate <NSObject>

@optional

- (void)blueToothDidConnect:(SZBlueTooth *)blueTooth;
- (void)blueTooth:(SZBlueTooth *)blueTooth DidGetData:(SZSndData *)data;

@end

@interface SZBlueTooth : NSObject

- (void)connect;

- (void)sendData:(SZSndData *)data;

@property (nonatomic, weak) id<SZBlueToothDelegate> delegate;

@end
