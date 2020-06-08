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
#import "ACJSON.h"

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

- (void)executeWithArguments:(NSArray *)args completionHandler:(void (^)(JSValue *returnValue))completionHandler DEPRECATED_MSG_ATTRIBUTE("AppCanKit: JavascriptCore 已经不再使用, 本方法过时，回调请使用 executeWithArguments:withCompletionHandler: 代替"){
    // AppCanWKTODO
    // JSValue相关的方法需要标记为作废，或者直接在h头文件中移除，迫使插件开发中逐渐改变回调方法，但是m文件中不要移除，保证引擎向前兼容老插件
    [self executeWithArguments:args];
}

- (void)executeWithArguments:(NSArray *)args withCompletionHandler:(nullable void (^)(_Nullable id, NSError * _Nullable error))completionHandler{
    // iOS13适配：增加保证在主线程的逻辑
    if([NSThread isMainThread]){
        [self executeOnCurrentThreadWithArguments:args completionHandler:completionHandler];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self executeOnCurrentThreadWithArguments:args completionHandler:completionHandler];
        });
    }
}

- (void)executeOnCurrentThreadWithArguments:(NSArray *)args completionHandler:(nullable void (^)(_Nullable id, NSError * _Nullable error))completionHandler{
    // AppCanWKTODO
    NSString *flag = @"1"; // 本callback是否还会有下一次回调，0没有，1有。
    NSMutableString *callbackJsStr = [NSMutableString stringWithCapacity:0];
    [callbackJsStr appendString:@"uexCallback.callback("];
    [callbackJsStr appendString:_functionId];
    [callbackJsStr appendString:@","];
    [callbackJsStr appendString:flag];
    for (int i = 0; i < args.count; i++) {
        [callbackJsStr appendString:@","];
        id arg = args[i];
        if ([arg isKindOfClass:[NSString class]]) {
            // string类型
            [callbackJsStr appendString:@"\'"];
            [callbackJsStr appendString:arg];
            [callbackJsStr appendString:@"\'"];
        }else if([arg isKindOfClass:[NSNumber class]]){
            // NSNumber内需要进一步判断
            // 由于BOOL类型无法准确区分，故不做区分。如果想回调true 和 false，直接用字符串类型。
//            if (strcmp([arg objCType], @encode(BOOL))) {
//                // boolean类型
//                NSString *argToStr = arg ? @"true" : @"false";
//                [callbackJsStr appendString:argToStr];
//            }else{
                // number类型
            NSString *argToStr = [NSString stringWithFormat:@"%@", arg];
            [callbackJsStr appendString:argToStr];
//            }
        }else{
            // object类型
            NSString *argToStr = [arg ac_JSONFragment];
            [callbackJsStr appendString:argToStr];
        }
    }
    [callbackJsStr appendString:@");"];
    [_ctx ac_evaluateJavaScript:callbackJsStr completionHandler:completionHandler];
}

- (void)executeWithArguments:(NSArray *)args{
    [self executeWithArguments:args withCompletionHandler:nil];
}

- (void)clean{
    NSString *cleanCbStr = [NSString stringWithFormat:@"uexCallback.clean(%@)", _functionId];
    [self.ctx ac_evaluateJavaScript:cleanCbStr];
}

/**
 本实例被回收的时候，应该顺便把JS中对应的function也移除
 */
- (void)dealloc{
    // AppCanWKTODO
    ACLogVerbose(@"AppCan===>ACJSFunctionRef===> dealloc, isMainThread? %d", [NSThread isMainThread]);
    // iOS13适配：增加保证在主线程的逻辑
    if([NSThread isMainThread]){
        [self clean];
        self.ctx = nil;
        ACLogVerbose(@"js funcRef %@ dealloc", self);
    } else {
        // 这里之所以使用sync而不是async，是因为dealloc函数执行完毕后，self对象就会被销毁了，此处必须是同步方法。如果异步，则其中某些访问self的操作会出现异常情况（或者无法起到预期的作用）
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self clean];
            self.ctx = nil;
            ACLogVerbose(@"js funcRef %@ dealloc", self);
        });
    }
}



@end
