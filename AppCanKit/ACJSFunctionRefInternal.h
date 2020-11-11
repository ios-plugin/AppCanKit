/**
 *
 *	@file   	: ACJSFunctionRefInternal.h  in AppCanKit
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

#import <AppCanKit/AppCanObjectProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@interface ACJSFunctionRef()

// 解释：由于是WKWebView的实例，为了避免引起不必要的内存泄露，JS方法执行逻辑中持有定义为weak。当被回收时，此处可能会是nil，那也是正常情况，就应当无法执行了。这取决于强引用WKWebView的地方何时销毁它。 by yipeng
@property (nonatomic, weak)id<ACJSContext> ctx;
@property(nonatomic, strong) NSString *functionId;

/**
 通过ID记录来实例化一个JS方法，用于执行AppCanJS回调
 
 @param functionId callback function id
 @return 抽象的JS方法实例
 */
+ (instancetype)functionRefWithACJSContext:(id<ACJSContext>)context fromFunctionId:(NSString *)functionId;

@end

NS_ASSUME_NONNULL_END
