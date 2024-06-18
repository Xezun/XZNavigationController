//
//  XZRuntime.h
//  XZKit
//
//  Created by Xezun on 2019/3/27.
//  Copyright © 2019 XEZUN INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 动态创建类
/// @define
/// 构造 Class 的块函数。
/// @param newClass 构造过程中的 Class 对象，只可用来添加变量、方法，不可直接实例化
typedef void (^XZRuntimeCreateClassBlock)(Class newClass);

/// 派生子类或创建新类。
/// @param superClass 新类的超类，如果为 Nil 则表示创建基类
/// @param name 新类的类名
/// @param block 给新类添加实例变量的操作必须在此block中执行
FOUNDATION_EXPORT Class _Nullable xz_objc_createClassWithName(Class _Nullable superClass, NSString *name, NS_NOESCAPE XZRuntimeCreateClassBlock _Nullable block);

/// 派生子类。
/// @note 子类命名`XZKit.SuperClassName[.0-1023]`最多可派生 1025 个子类。
/// @param superClass 新类的超类
/// @param block 给新类添加实例变量的操作必须在此block中执行
FOUNDATION_EXPORT Class _Nullable xz_objc_createClass(Class superClass, NS_NOESCAPE XZRuntimeCreateClassBlock _Nullable block);


#pragma mark - 给类添加方法

/// 给类 target 添加方法。
/// @note 方法
/// @param target 待添加方法的类
/// @param method 方法
/// @param implementation block 形式的方法实现，如果提供，则会优先使用该 block 作为方法实现
FOUNDATION_EXPORT BOOL xz_objc_class_addMethodByCopyingMethod(Class target, Method method, id _Nullable implementation);

/// 给类添加实例方法：将 source 的方法 selector 拷贝到 target 上。
/// @param target 待添加方法的类
/// @param source 被复制方法的类
/// @param selector 方法名
/// @param implementation 如果提供，则使用 block 作为方法实现，其中 block 形如 `ReturnType ^(id self, args …)` 即第一个参数是对象实例对象，后面是方法参数
/// @return 当 target 已存在 selector 方法时，本函数返回 NO
FOUNDATION_EXPORT BOOL xz_objc_class_addMethodByCopyingClass(Class target, Class source, SEL selector, id _Nullable implementation);

/// 将 source 的所有实例方法（不包括超类）都复制到 target 上。
/// @param target 待添加方法的类
/// @param source 被复制方法的类
/// @return 被成功复制的方法的数量
FOUNDATION_EXPORT NSInteger xz_objc_class_copyMethodsFromClass(Class target, Class source);

#pragma mark - 其他方法

/// 将指定类的 方法1 与 方法2 的方法体互换。
/// @note 如果 方法1 不存在（包括继承自父类但是没有重写的方法），则给类增加一个与方法2相同方法体的方法。
/// @param aClass 需要替换方法体的类。
/// @param selector1 待交换方法体的方法。
/// @param selector2 被交换方法体的方法。
FOUNDATION_EXPORT void xz_objc_class_exchangeMethodsImplementations(Class aClass, SEL selector1, SEL selector2);

/// 遍历类实例对象的变量，不包括父类。
/// @param aClass 类。
/// @param block 遍历所用的 block 。
FOUNDATION_EXPORT void xz_objc_class_enumerateVariables(Class aClass, void (^block)(Ivar ivar));

/// 获取类实例对象的变量名。
/// @param aClass 类。
FOUNDATION_EXPORT NSArray<NSString *> * _Nullable xz_objc_class_getVariableNames(Class aClass);

/// 遍历类实例对象的方法，不包括父类的方法。
/// @param aClass 类。
/// @param block 遍历所用的 block 。
FOUNDATION_EXPORT void xz_objc_class_enumerateMethods(Class aClass, void (^block)(Method method));

/// 获取类实例对象的方法名。
/// @param aClass 类。
FOUNDATION_EXPORT NSArray<NSString *> * _Nullable xz_objc_class_getMethodSelectors(Class aClass);

NS_ASSUME_NONNULL_END
