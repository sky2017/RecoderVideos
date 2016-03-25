//
//  ViewController.m
//  RecoderVideos
//
//  Created by Bruce on 16/3/17.
//  Copyright © 2016年 Bruce. All rights reserved.
//

/*
    UIImagePickerController
    设置访问摄像头 或者 相册:sourceType
    前后摄像头:默认后置摄像头 cameraDevice
    设置拍照录像 ->录像->设置媒体类型->KUTTypeMovie -><MobileCoreServices>->转换成NSString
    设置 闪光灯模式
    拍照
    开始录像
    结束录像
    代理 需要导入UINavigationControllerDelegate,UIImagePickerControllerDelegate
    是否显示 控制控件
    覆盖视图
    录像的清晰度
    视频的最大录制时间
    
    保存图片到相册UIImageWriteToSavedPhotosAlbum:
    保存完成之后的回调
    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 
 */


#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+Transfrom.h"


#define SCREEN_BOUNDS [UIScreen mainScreen].bounds//屏幕尺寸
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)//屏幕宽
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)//屏幕高

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UILabel *showTypeLabel;//显示 拍照或者 录像的 控件
    BOOL isMovie;//判断 拍照 摄像的依据
    
    UIImageView *showMediaView;//显示 拍照 录像结果的视图
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwitch *mediaSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 50, 50, 50)];
    [mediaSwitch addTarget:self action:@selector(changeMediaType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mediaSwitch];
    

    showTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(mediaSwitch.frame), CGRectGetMinY(mediaSwitch.frame)-30, 50, 20)];
    showTypeLabel.textAlignment = NSTextAlignmentCenter;
    showTypeLabel.textColor = [UIColor colorWithRed:0.0078 green:0.6396 blue:1.0 alpha:1.0];
    showTypeLabel.text = @"拍照";
    [self.view addSubview:showTypeLabel];
    
    
    
    showMediaView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 150, 200)];
    [self.view addSubview:showMediaView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"Camera" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor brownColor];
    [button addTarget:self action:@selector(doit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)changeMediaType:(UISwitch *)sender{
    [showTypeLabel rotation];
    
    showTypeLabel.text = sender.isOn!=YES ? @"拍照":@"录像";
    isMovie = sender.isOn;
}

- (void)doit{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
//    选择摄像头设备
//    默认的是选择相册
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (isMovie==YES) {
        //    选择媒体类型
        //    拍照的时候 不选择 媒体类型 不会崩溃 是因为 默认设置是kUTTypeImage
        //    kUTTypeImage -> 包含在MobileCoreServices这个框架中->需要的内容不是OC里面的字符串类型  需要强制转换
        //    录制视频 类型要选择kUTTypeMovie 它里面包含了 audio video
        pickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        
        //    设置录像 默认拍照 -> 要先选择媒体的类型
        //    ✭✭✭✭✭ 不然崩溃
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
    
//    delegate 包含两个 代理协议
//    UINavigationControllerDelegate
//    UIImagePickerControllerDelegate
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"完成");
    
//    NSLog(@">>:%@",info);
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
        NSLog(@"我在录像 录完了");
    }
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        NSLog(@"我在拍照 拍完了");
        
        UIImage *finishImage = info[UIImagePickerControllerOriginalImage];
        
        showMediaView.image = nil;
        showMediaView.image = finishImage;
        NSData *imageData = UIImageJPEGRepresentation(finishImage, 0.1);
        NSData *imageData1 = UIImagePNGRepresentation(finishImage);
        
//        把照片 保存到相册
        UIImageWriteToSavedPhotosAlbum(finishImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存成功  回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"图片保存成功");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
