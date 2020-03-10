//
//  ViewController.m
//  性能优化
//
//  Created by 张倍浩 on 2020/3/8.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
/*
 卡顿优化 - CPU
 1. 尽量使用轻量级的对象，比如用不到事件处理的地方，可以考虑使用CALayer取代UIView
 2. 不要频繁地调用UIView的相关属性，比如frame、bounds、transform等属性，尽量减少不必要的修改
 3. 尽量提前计算好布局，在有需要时一次性调整对象的属性，不要多次修改属性
 4. AutoLayout会比直接设置frame消耗更多的CPU资源
 5. 图片的size最好刚好跟UIImageView的size保持一致
 6. 控制一下线程的最大并发数量
 7. 尽量把耗时的操作放到子线程，如：文本处理（尺寸计算、绘制）、图片处理（解码、绘制）
 
 卡顿优化 - GPU
 1. 尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示
 2. GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸
 3. 尽量减少视图数量和层次
 4. 减少透明的视图（alpha < 0），不透明的就设置opaque为YES
 5. 尽量避免出现离屏渲染
 
 耗电优化
 1. 尽可能减少CPU、GPU功耗
 2. 少用定时器
 3. 优化I/O操作
    1）尽量不要频繁写入小数据，最好批量一次性写入
    2）读写大量重要数据时，考虑dispatch_io，其提供了基于GCD的异步操作文件I/O的API，用dispatch_io系统会优化磁盘访问
    3）数据量比较大的，建议使用数据库（比如SQLite，CoreData）
 4. 网络优化
    1）减少、压缩网络数据
    2）如果多次请求的结果是相同的，尽量使用缓存
    3）使用断点续传，否则网络不稳定时可能多次传输相同的内容
    4）网络不可用时，不要尝试执行网络请求
    5）让用户可以取消长时间运行或者速度很慢的网络操作，设置合适的超时时间
    6）批量传输，比如，下载视频流时，不要传输很小的数据包，直接下载整个文件或者一大块一大块地下载，如果下载广告，一次性多下载一些，然后再慢慢展示。如果下载电子邮件，一次下载多封，不要一封一封地下载
 5. 定位优化
    1）如果只是需要快速确定用户位置，最好用CLLocationManager的requestLocation方法。定位完成后，会自动让定位硬件断电
    2）如果不是导航应用，尽量不要实时更新位置，定位完毕就关掉定位服务
    3）尽量降低定位精度，比如尽量不要使用精度最高的kCLLocationAccuracyBest
    4）需要后台定位时，尽量设置pausesLocationUpdatesAutomatically为YES，如果用户不太可能移动的时候系统会自动暂停位置更新。
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableURLRequest *request;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tt)];
//        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
//    });

    CLLocationManager *manager;
    [manager requestLocation];
    manager.pausesLocationUpdatesAutomatically = YES;
}

- (void)tt {
    NSLog(@"111");
}

#pragma mark 图片异步解码
- (void)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
//    // 网络下载的图片
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL new]]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef cgImage = [UIImage imageNamed:@"testImg"].CGImage;
        
        // alphaInfo
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        
        // bitmapInfo
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        
        // size
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        
        // context
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
        
        // draw
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
        
        // get CGImage
        cgImage = CGBitmapContextCreateImage(context);
        
        // into UIImage
        UIImage *newImage = [UIImage imageWithCGImage:cgImage];
        
        // release
        CGContextRelease(context);
        CGImageRelease(cgImage);
        
        // back to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = newImage;
        });
    });
}

@end
