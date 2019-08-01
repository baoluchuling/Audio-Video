//
//  BCCPUMonitor.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/6/3.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCCPUMonitor.h"

#include <mach/task_info.h>
#include <mach/mach.h>

@implementation BCCPUMonitor

+ (double)obtainCPUUsage
{
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kern_return_t kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    double tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    //free mem
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}

@end
