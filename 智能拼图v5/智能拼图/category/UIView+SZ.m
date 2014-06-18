//
//  UIView+SZ.m
//  智能拼图
//
//  Created by mac on 14-5-27.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import "UIView+SZ.h"

@implementation UIView (SZ)
- (UIImage *)changeToImage
{
    
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (NSMutableArray *)showWithImages : (NSArray *)images andOptionSel:(SEL)sel andContex:(id)contex
{
    
    // 清空原来的view
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *centers = [NSMutableArray array];
    
    // 根据图片数组创建新的控件,添加到view上
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    NSInteger count = images.count;
    int column = sqrt(count);
    
    CGFloat btnW = viewW / column;
    CGFloat btnH = viewH / column;
    
    for (int i = 0 ;i < count; ++i) {
        CGFloat btnX = (i % column) * btnW;
        CGFloat btnY = (i / column) * btnH;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn setBackgroundImage:images[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:contex action:sel forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [[UIColor whiteColor] CGColor];
        btn.layer.borderWidth = 1;
        if (i != count - 1) {
            [self addSubview:btn];
        }
        [centers addObject:NSStringFromCGPoint(btn.center)];
    }

    return centers;
}
@end
