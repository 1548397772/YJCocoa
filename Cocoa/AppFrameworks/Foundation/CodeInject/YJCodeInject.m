//
//  YJCodeInject.h
//  YJCocoa
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 2019/3/5.
//  Copyright © 2019年 YJCocoa. All rights reserved.
//

#import "YJCodeInject.h"
#import <dlfcn.h>
#import <mach-o/getsect.h>

@implementation YJCodeInject

+ (void)executeFunctionForKey:(NSString *)key {
    NSString *sectname = [NSString stringWithFormat:@"%@f", key?:@""];
    Dl_info info;
    dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &info);
    const uint64_t mach_header = (uint64_t)info.dli_fbase;
    const struct section_64 *section = getsectbynamefromheader_64((void *)mach_header, "__YJCocoa", sectname.UTF8String);
    if (section == NULL) return;
    int addrOffset = sizeof(struct YJCI_Function);
    for (uint64_t addr = section->offset; addr < section->offset + section->size; addr += addrOffset) {
        struct YJCI_Function entry = *(struct YJCI_Function *)(mach_header + addr);
        entry.function();
    }
}

+ (void)executeBlockForKey:(NSString *)key {
    NSString *sectname = [NSString stringWithFormat:@"%@b", key?:@""];
    Dl_info info;
    dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &info);
    const uint64_t mach_header = (uint64_t)info.dli_fbase;
    const struct section_64 *section = getsectbynamefromheader_64((void *)mach_header, "__YJCocoa", sectname.UTF8String);
    if (section == NULL) return;
    int addrOffset = sizeof(struct YJCI_Block);
    for (uint64_t addr = section->offset; addr < section->offset + section->size; addr += addrOffset) {
        struct YJCI_Block entry = *(struct YJCI_Block *)(mach_header + addr);
        !entry.block ?: entry.block();
    }
}

@end
