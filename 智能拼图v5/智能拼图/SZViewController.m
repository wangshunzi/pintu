//
//  SZViewController.m
//  智能拼图
//
//  Created by mac on 14-5-25.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

// 动画执行速度(每毫秒执行)
#define kSeconds 0.001
// 打乱次数
#define kCount 600

#import "SZViewController.h"
#import "UIImage+SZ.h"
#import "SZSndData.h"
#import "MBProgressHUD+MJ.h"
#import "SZBlueTooth.h"
#import "UIView+SZ.h"



@interface SZViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,SZBlueToothDelegate>
{
    // 记录当前可移动的位置索引
    NSInteger currentCanMoveIndex;
    // 时钟,用于执行打乱行为
    __block NSTimer *_timer;
    // 是否进入判定输赢模式
    BOOL _judgeWin;

    NSArray *_images;
}
// 控件属性
@property (weak, nonatomic) IBOutlet UIView *imagePan;
@property (weak, nonatomic) IBOutlet UIView *optionPan;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UILabel *otherScore;
@property (weak, nonatomic) IBOutlet UILabel *otherTime;
@property (weak, nonatomic) IBOutlet UIImageView *origernImg;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UISlider *levelSelect;
@property (weak, nonatomic) IBOutlet UIImageView *otherImg;
- (IBAction)connectFriend;




// 正确答案排列数组
@property (nonatomic, strong) NSArray *correctArray;
// 记录控件的位置信息
@property (nonatomic, strong) NSMutableArray *centers;
// 标识总共是几乘几的矩阵,例如3 x 3
@property (nonatomic, assign) NSInteger totalSubCount;
// 当前切片后的图片数组
@property (nonatomic, strong) NSArray *images;
// 当前正在使用的图片
@property (nonatomic, strong) UIImage *currentImage;
// 用于游戏计时操作
@property (nonatomic, strong) NSTimer *timer;
// 蓝牙工具
@property (nonatomic, strong) SZBlueTooth *blueTooth;


@end

@implementation SZViewController

// 初始化操作
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalSubCount = 9;
	_judgeWin = NO;
   
}

#pragma mark - 懒加载数据
-(SZBlueTooth *)blueTooth
{
    if (_blueTooth == nil) {
        _blueTooth = [[SZBlueTooth alloc] init];
        _blueTooth.delegate = self;
    }
    return _blueTooth;
}



-(void)setCurrentImage:(UIImage *)currentImage
{
    if (_currentImage != currentImage) {
        _currentImage = nil;
        _currentImage = currentImage;
        _images = nil;
        _centers = nil;
    }
}

-(void)setTotalSubCount:(NSInteger)totalSubCount
{
    if (_totalSubCount != totalSubCount) {
        _totalSubCount = totalSubCount;
        _images = nil;
        _centers = nil;
        [self restart];
    }
}

-(NSArray *)images
{
    if (_images == nil) {
         _images = [self.currentImage createSubImageWithCount:self.totalSubCount];
    }
    return _images;
}

-(void)setImages:(NSArray *)images
{
    if (![_images isEqualToArray:images]) {
        _images = nil;
        _images = images;
    }
}

// 连接好友
- (IBAction)connectFriend {
    [self.blueTooth connect];
}

// 选取自定义图片
- (IBAction)selectImg {
    
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    imageVC.delegate = self;
    imageVC.allowsEditing = YES;
    imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imageVC animated:YES completion:nil];
    
}

// 选择难度
- (IBAction)levelsel:(UISlider *)slider {
    int value = (int)(slider.value + 0.5);
    slider.value = value;
    self.totalSubCount = (3 + value) * (3 + value);
    
}

// 重新开始
- (IBAction)restart {
    if (self.currentImage != nil) {
        [self beginWithDismissPicker:nil];
    }
}


// 开始游戏
- (void)beginWithDismissPicker : (UIImagePickerController *)picker
{
 
    self.centers = [self.imagePan showWithImages:self.images andOptionSel:@selector(move:) andContex : self];
    self.correctArray = nil;
    self.correctArray = [self.imagePan.subviews valueForKeyPath:@"tag"];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    // 记录当前可移动坐标索引
    currentCanMoveIndex = self.totalSubCount - 1;
    // 设置自动打乱顺序
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:kSeconds target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    // 进入不判断输赢模式
    _judgeWin = NO;
   
}


// 开始计时
- (void)beginStart
{
    [self clearAll];
    [self endStart];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

// 计时操作
- (void)timeAdd
{
    [self.useTime setText:[NSString stringWithFormat:@"%d",[self.useTime.text intValue]+1]];
}

// 结束计时
- (void)endStart
{
    [self.timer invalidate];
    self.timer = nil;
}

// 清空记录
- (void)clearAll
{
    self.score.text = @"0";
    self.useTime.text = @"0";
}





// 自动移动,打乱拼图顺序
- (void)autoMove
{
    // 进入不判定输赢状态
    _judgeWin = NO;
    static int count = kCount; //记录打乱次数
    count --;
    if (count == 0) {
        [_timer invalidate];
        _timer = nil;
        _judgeWin = YES;
        count = kCount;
        [self beginStart];
    }
        NSArray *canMoveIndexs = [self canMoveIndexs];
        int index = arc4random_uniform(canMoveIndexs.count);
        
        int btnIndex = [canMoveIndexs[index] intValue];
  
    
        UIButton *btn = (UIButton *)[self.imagePan viewWithTag:btnIndex];
    if (btnIndex == 0) {
        btn = [self.imagePan.subviews firstObject];
    }
    [self move:btn];
   
    
   
}
// 图片按钮移动
- (void)move:(UIButton *)btn
{
    NSArray *canMoveIndexs = [self canMoveIndexs];
    if ([canMoveIndexs containsObject:@(btn.tag)]) {
        [UIView animateWithDuration:0.1 animations:^{
            btn.center = CGPointFromString(self.centers[currentCanMoveIndex]);
        } completion:nil];
        NSInteger temp = currentCanMoveIndex;
        currentCanMoveIndex = btn.tag;
        btn.tag = temp;
        
    }
    
    if (_judgeWin) {
        
        // 每次移动,判断是否完成拼图
       NSArray *nowAnswerArray =[self.imagePan.subviews valueForKeyPath:@"tag"];
        SZSndData *data = [[SZSndData alloc] init];
        if ([nowAnswerArray isEqualToArray:self.correctArray]) {
            self.score.text = [NSString stringWithFormat:@"%d",[self.score.text intValue] + 10];
            UILabel *warnLable = [[UILabel alloc] initWithFrame:self.imagePan.bounds];
            warnLable.text = @"哥已经赢了!!";
            data.isWin = @"1";
            warnLable.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0.5];
            warnLable.textAlignment = NSTextAlignmentCenter;
            warnLable.userInteractionEnabled = YES;
            [self.imagePan addSubview:warnLable];
            [self endStart];
        }
        
        // 连接好友后进行数据传输
        if (_blueTooth) {
            UIImage *image = [self.imagePan changeToImage];
            data.image = image;
            data.costTime = self.useTime.text;
            data.score = self.score.text;
            data.isConnect = @"1";
            [self.blueTooth sendData:data];
        }
       
        
    }
    
    
    
}

// 返回当前可移动的索引数组
- (NSArray *)canMoveIndexs
{
    NSInteger count = self.totalSubCount;
    int column = sqrt(count);
    // 计算当前可移动的索引上下左右的索引数组
    NSMutableArray *canMoveIndexs = [NSMutableArray arrayWithObjects:
                                     @(currentCanMoveIndex - 1),
                                     @(currentCanMoveIndex + 1),
                                     @(currentCanMoveIndex + column),
                                     @(currentCanMoveIndex - column), nil];
    // 去除错误索引
    if (currentCanMoveIndex % column == 0) { // 在最左边
        [canMoveIndexs removeObject:@(currentCanMoveIndex - 1)];
    }
    else if (currentCanMoveIndex % column == column - 1) // 在最右边
    {
        [canMoveIndexs removeObject:@(currentCanMoveIndex + 1)];
    }
    if (currentCanMoveIndex / column == 0) { // 在最上边
        [canMoveIndexs removeObject:@(currentCanMoveIndex - column)];
    }
    else if (currentCanMoveIndex / column == column - 1) // 在最下边
    {
        [canMoveIndexs removeObject:@(currentCanMoveIndex + column)];
    }
    return canMoveIndexs;
    
}

#pragma mark - 蓝牙工具代理方法
- (void)blueToothDidConnect:(SZBlueTooth *)blueTooth
{
    NSLog(@"test");
    [self.connectBtn setTitle:@"已连接好友" forState:UIControlStateNormal];
    self.connectBtn.enabled = NO;
    SZSndData *data = [[SZSndData alloc] init];
    data.isConnect = @"1";
    [blueTooth sendData:data];
}
- (void)blueTooth:(SZBlueTooth *)blueTooth DidGetData:(SZSndData *)data
{
    UIImage *image = data.image;
    self.otherImg.image = image;
    self.otherScore.text = data.score;
    self.otherTime.text = data.costTime;
    
    if ([data.isConnect isEqualToString:@"1"]) {
        self.connectBtn.enabled = NO;
    }
    if ([data.isWin isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"你输了!煞笔!"];
    }
    

}

#pragma mark - 图片选择器代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.currentImage = image;
    self.origernImg.image = image;
    
    [self beginWithDismissPicker:picker];
}



-(NSString *)description
{
    return [NSString stringWithFormat:@"images:%@----imagesPan : %@",self.images,self.imagePan.subviews];
}
@end
