//
//  DownloadViewController.m
//  JRBgSessionDemo
//
//  Created by sky on 2017/3/24.
//  Copyright © 2017年 sky. All rights reserved.
//

#import "DownloadViewController.h"
#import "JRProgressView.h"
#import "AppDelegate.h"

@interface DownloadViewController () <NSURLSessionDelegate,NSURLSessionDownloadDelegate>

/** background session */
@property (nonatomic, strong) NSURLSession *session;

/** task */
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet JRProgressView *progressView;

@end

@implementation DownloadViewController

- (NSURLSession *)backgroundSession
{
    static NSURLSession *_backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.Jerry4me.backgroundSessionIdentifier"];
        _backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    });

    return _backgroundSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.session = [self backgroundSession];
}

- (IBAction)start {
    if(self.task) return;
    
    
    
    NSURL *URL = [NSURL URLWithString:@"http://www.bz55.com/uploads/allimg/140402/137-140402153504.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    self.task = [self.session downloadTaskWithRequest:request];
    
    [self.task resume]; // 可以不手动调用, App进入后台系统会自动开启任务
    
    self.imageView.hidden = YES;
    self.progressView.hidden = NO;

}



#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{

    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    NSLog(@"下载中 - %.0f%%", progress * 100);
    
    // 回到主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
       self.progressView.progress = progress;
       
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{

    NSLog(@"%s", __func__);
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"pic.jpg"];

    // 保存图片
    [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:path error:nil];
    // 显示图片
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        self.imageView.image = image;
        self.imageView.hidden = NO;
        self.progressView.hidden = YES;
    });
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    
    self.task = nil;

    if (error) {
        NSLog(@"%@", error);
    }
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"%s", __func__);
    
    // 调用handler告诉系统
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
#warning 注意! 模拟器是不会调用delegate.handler的, 只有真机才会调用
    if(delegate.handler) {
    
        completionHandler handler = delegate.handler;
        delegate.handler = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{ // 由于系统提供的completionHandler是UIKit的一部分, 所以需要回到主线程调用
            handler();
        });
    }
    
    
}

@end
