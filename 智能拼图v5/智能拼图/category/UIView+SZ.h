//
//  UIView+SZ.h
//  智能拼图
//
//  Created by mac on 14-5-27.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SZ)
// 将View生成图片
- (UIImage *)changeToImage;

// 返回内部控件的中点坐标数组
- (NSMutableArray *)showWithImages : (NSArray *)images andOptionSel : (SEL)sel andContex : (id)contex;
@end
