//
//  ViewController.m
//  GCD_demo
//
//  Created by sve on 2018/6/22.
//  Copyright © 2018年 sve. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self asyncCon];
}


// 同步 并发  begin 任务1 2 3 end 不开线程
- (void)syncCont {
    dispatch_queue_t queue = dispatch_queue_create("sv_gcd_demo", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"begin");
    dispatch_sync(queue, ^{
        NSLog(@"任务1");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务2");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务3");
    });
    NSLog(@"end");
}

// 同步 串行 begin 任务1 2 3  end 不开线程
- (void)syncSeri {
    dispatch_queue_t queue = dispatch_queue_create("sv_gcd_demo", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin");
    dispatch_sync(queue, ^{
        NSLog(@"任务1");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务2");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务3");
    });
    NSLog(@"end");
}
//------------------------------------------同步串行 VS 同步并发 结果是一样的

// 异步串行 begin end 任务1 2 3 线程2条
- (void)asyncSeri {
    dispatch_queue_t queue = dispatch_queue_create("sv_gcd_demo", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin");
    dispatch_async(queue, ^{
        NSLog(@"任务1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务2");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务3");
    });
    NSLog(@"end");
}

// 异步并发 begin end 任务1 2 3 线程4条(开辟3条)!!!错了 不一定几条,最多新开辟3条
- (void)asyncCon {
    dispatch_queue_t queue = dispatch_queue_create("sv_gcd_demo", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"begin-%@",[NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"任务1-%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务2-%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务3-%@",[NSThread currentThread]);
    });
    NSLog(@"end-%@",[NSThread currentThread]);
}


// 嵌套 begin end 1 3 2  开一条线程
- (void)asyncSerNest {
    dispatch_queue_t queqe = dispatch_queue_create("sv.dispatch", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin-%@",[NSThread currentThread]);
    dispatch_async(queqe, ^{
        NSLog(@"1-%@",[NSThread currentThread]);
        dispatch_async(queqe, ^{
            NSLog(@"2-%@",[NSThread currentThread]);
        });
        NSLog(@"3-%@",[NSThread currentThread]);
    });
    NSLog(@"end-%@",[NSThread currentThread]);
}

// 串行队列,死锁
- (void)asyncSyncSerNest {
    dispatch_queue_t queqe = dispatch_queue_create("sv.dispatch", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin-%@",[NSThread currentThread]);
    dispatch_async(queqe, ^{
        NSLog(@"1-%@",[NSThread currentThread]);
        dispatch_sync(queqe, ^{
            NSLog(@"2-%@",[NSThread currentThread]);
        });
        NSLog(@"3-%@",[NSThread currentThread]);
    });
    NSLog(@"end-%@",[NSThread currentThread]);
}


// 死锁
- (void)syncLock {
    NSLog(@"begin-%@",[NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
       NSLog(@"1-%@",[NSThread currentThread]);
    });
    NSLog(@"end-%@",[NSThread currentThread]);
}

- (void)juejin1 {
    NSLog(@"1");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"2");
    });
    NSLog(@"3"); // 1 2 3
}

- (void)hitAlibb1 {
    NSLog(@"1-%@",[NSThread currentThread]); // 任务1
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"2-%@",[NSThread currentThread]); // 任务2
    });
    NSLog(@"3-%@",[NSThread currentThread]); // 任务3
} // 1 2 3 1个线程!!!!! 没有async就不会开线程

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hitAlibb1];
}

@end

// 添加任务的顺序??
