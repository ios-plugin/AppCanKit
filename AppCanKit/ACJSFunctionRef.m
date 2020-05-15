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
//#import "ACJSValueSupport.h"
#import "ACJSFunctionRefInternal.h"
#import "ACLog.h"



@implementation ACJSFunctionRef

+ (instancetype)functionRefFromJSValue:(JSValue *)value{
    // AppCanWKTODO
//    if (!value || value.ac_type != ACJSValueTypeFunction) {
//        return nil;
//    }
    
    
    ACJSFunctionRef *funcRef = [[self alloc]init];
//    if (funcRef) {
//        JSContext *ctx = value.context;
//
//
//        funcRef.ctx = ctx;
//        funcRef.identifier = [NSUUID UUID].UUIDString;
//        funcRef.managedFunction = [[JSManagedValue alloc]initWithValue:value];
//        funcRef.machine = value.context.virtualMachine;
//        [funcRef.machine addManagedReference:funcRef.managedFunction withOwner:self];
//
//        JSValue *intenal = ctx[@"_ACJSFunctionRefIntenal"];
//        if ([intenal isUndefined]) {
//            intenal = [JSValue valueWithObject:@{} inContext:ctx];
//            ctx[@"_ACJSFunctionRefIntenal"] = intenal;
//        }
//
//        intenal[funcRef.identifier] = value;
//        ACLogVerbose(@"js funcRef %@ init",funcRef);
//    }
    return funcRef;

}


- (void)executeWithArguments:(NSArray *)args completionHandler:(void (^)(JSValue *returnValue))completionHandler{
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
//    JSValue *value = self.managedFunction.value;
//    if (!value) {
//        value = self.ctx[@"_ACJSFunctionRefIntenal"][self.identifier];
//    }
//    if (value) {
//        [value ac_callWithArguments:args completionHandler:completionHandler];
//    }else{
//        if (completionHandler) {
//            completionHandler(nil);
//        }
//    }
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
