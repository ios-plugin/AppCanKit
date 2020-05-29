/**
 *
 *	@file   	: ACJSFunctionRef.m  in AppCanKit
 *
 *	@author 	: CeriNo 
 * 
 *	@date   	: Created on 16/5/30.
 *
 *	@copyright 	: 2016 The AppCan Open Source Project.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "ACJSFunctionRef.h"
#import "ACJSContext.h"
#import "ACJSFunctionRefInternal.h"
#import "ACLog.h"

@implementation ACJSFunctionRef

+ (instancetype)functionRefWithACJSContext:(id<ACJSContext>)context fromFunctionId:(NSString *)functionId{
    // AppCanWKTODO
    ACJSFunctionRef *funcRef = [[self alloc]init];
    if (funcRef) {
        funcRef.ctx = context;
        funcRef.functionId = functionId;
        ACLogVerbose(@"js funcRef %@ init",funcRef);
    }
    return funcRef;
}


- (void)executeWithArguments:(NSArray *)args completionHandler:(void (^)(JSValue *returnValue))completionHandler{
    // AppCanWKTODO
    // JSValue相关的方法需要标记为作废，或者直接在h头文件中移除，迫使插件开发中逐渐改变回调方法，但是m文件中不要移除，保证引擎向前兼容老插件
    // iOS13适配：增加保证在主线程的逻辑
    if([NSThread isMainThread]){
        [self executeOnCurrentThreadWithArguments:args completionHandler:completionHandler];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self executeOnCurrentThreadWithArguments:args completionHandler:completionHandler];
        });
    }
}


- (void)executeOnCurrentThreadWithArguments:(NSArray *)args completionHandler:(void (^)(JSValue *returnValue))completionHandler{
    // AppCanWKTODO
    NSString *flag = @"1";
    NSMutableString *callbackJsStr = [NSMutableString stringWithCapacity:0];
    [callbackJsStr appendString:@"javascript:uexCallback.callback("];
    [callbackJsStr appendString:_functionId];
    [callbackJsStr appendString:@","];
    [callbackJsStr appendString:flag];
    for (int i = 0; i < args.count; i++) {
        [callbackJsStr appendString:@","];
        
    }
//    _ctx ac_evaluateJavaScript:<#(NSString *)#>
}

- (void)executeWithArguments:(NSArray *)args{
    [self executeWithArguments:args completionHandler:nil];
}

- (void)dealloc{
    // AppCanWKTODO
    ACLogVerbose(@"AppCan===>ACJSFunctionRef===> dealloc, isMainThread? %d", [NSThread isMainThread]);
    // iOS13适配：增加保证在主线程的逻辑
//    if([NSThread isMainThread]){
//        self.ctx[@"_ACJSFunctionRefIntenal"][self.identifier] = nil;
//        [self.machine removeManagedReference:_managedFunction withOwner:self];
//        self.machine = nil;
//        _managedFunction = nil;
//        self.ctx = nil;
//        ACLogVerbose(@"js funcRef %@ dealloc",self);
//    } else {
//        // 这里之所以使用sync而不是async，是因为dealloc函数执行完毕后，self对象就会被销毁了，此处必须是同步方法。如果异步，则其中某些访问self的操作会出现异常情况（或者无法起到预期的作用）
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            self.ctx[@"_ACJSFunctionRefIntenal"][self.identifier] = nil;
//            [self.machine removeManagedReference:_managedFunction withOwner:self];
//            self.machine = nil;
//            _managedFunction = nil;
//            self.ctx = nil;
//            ACLogVerbose(@"js funcRef %@ dealloc",self);
//        });
//    }
}



@end
