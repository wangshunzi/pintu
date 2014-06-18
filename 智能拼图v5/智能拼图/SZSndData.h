//
//  SZSndData.h
//  智能拼图
//
//  Created by apple on 14-5-24.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZSndData : NSObject

// 实时显示的游戏界面
@property(nonatomic, strong)UIImage *image;
// 分数
@property (nonatomic, copy) NSString *score;
// 花费事件
@property (nonatomic, copy) NSString *costTime;
// 连接状态
@property (nonatomic, copy) NSString *isConnect;
// 输赢状态
@property (nonatomic, copy) NSString *isWin;
@end
