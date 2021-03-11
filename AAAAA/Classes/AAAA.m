//
//  AAAA.m
//  AAAAA
//
//  Created by linxiaohai on 2021/3/11.
//

#import "AAAA.h"

#include<sys/param.h>
#include<sys/sysctl.h>

@implementation AAAA

+ (void)load {
    NSTimeInterval processStartTime = [[self class] processStartTime];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime = [date timeIntervalSince1970] * 1000;
    NSLog(@"processStartTime %lf",currentTime - processStartTime);
}

+ (BOOL)processInfoForPID:(int)pid procInfo:(struct kinfo_proc*)procInfo {
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(*procInfo);
    return sysctl(cmd, sizeof(cmd)/sizeof(*cmd), procInfo, &size, NULL, 0) == 0;
}

//  根据进程信息，获取具体的进程加载到内存中的时间戳
+ (NSTimeInterval)processStartTime {
    struct kinfo_proc kProcInfo;
    if ([[self class] processInfoForPID:[[NSProcessInfo processInfo] processIdentifier] procInfo:&kProcInfo]) {
        return (kProcInfo.kp_proc.p_un.__p_starttime.tv_sec * 1000.0 + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000.0);
    } else {
        NSAssert(NO, @"无法取得进程的信息");
        return 0;
    }
}

@end
