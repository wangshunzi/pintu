//
//  SZBlueTooth.m
//  智能拼图
//
//  Created by mac on 14-5-27.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import "SZBlueTooth.h"
@interface SZBlueTooth()<GKPeerPickerControllerDelegate>
{
        GKSession *_session;
    
}
@end
@implementation SZBlueTooth
- (void)connect
{
    if (_session == nil) {
        GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
        picker.delegate = self;
        [picker show];
    }
    
}

- (void)sendData:(SZSndData *)data
{
    [_session sendDataToAllPeers:[NSKeyedArchiver archivedDataWithRootObject:data] withDataMode:GKSendDataReliable error:nil];
}


#pragma mark - 蓝牙代理方法

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    
    _session = session;
    [_session setDataReceiveHandler:self withContext:nil];
    [picker dismiss];
    if ([self.delegate respondsToSelector:@selector(blueToothDidConnect:)])
    {
        [self.delegate blueToothDidConnect:self];
    }

 
    
}

// 接收数据
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    SZSndData *sdata = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([self.delegate respondsToSelector:@selector(blueTooth:DidGetData:)])
    {
        [self.delegate blueTooth:self DidGetData:sdata];
    }

}

@end
