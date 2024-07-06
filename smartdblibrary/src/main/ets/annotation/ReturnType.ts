import DbUtil from '../DbUtil';
import "reflect-metadata"

export function ReturnType(type): MethodDecorator {
  return (target, propertyKey, descriptor) => {
    Reflect.defineMetadata(DbUtil.RETURN_TYPE_KEY, type, target, propertyKey);
  }
}

export function ReturnNType(target: any, key: string | symbol, descriptor: PropertyDescriptor) {
  const originalMethod = descriptor.value;

  descriptor.value = function<T>(...args: any[]) {
    // 这里 args 包含了方法参数，可以在需要时使用

    // 获取方法的泛型类型 T
    const returnType = Reflect.getMetadata(DbUtil.RETURN_TYPE_KEY, target, key);

    // 设置方法的返回类型
    Reflect.defineMetadata(DbUtil.RETURN_TYPE_KEY, returnType, target, key);

    // 调用原始方法
    return originalMethod.apply(this, args);
  };

  return descriptor;
}

export function ReturnListType(type): MethodDecorator {
  return (target, propertyKey, descriptor) => {
    Reflect.defineMetadata(DbUtil.RETURN_TYPE_KEY, [type], target, propertyKey);
  }
}