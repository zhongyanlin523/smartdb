import "reflect-metadata"
import DbUtil from "../DbUtil"

export function Param(name: string, raw: boolean = false): ParameterDecorator {
  return (target, propertyKey, parameterIndex) => {
    // Logger.debug("%s.%s  param: %s  index: %d", target.constructor.name, propertyKey, name, parameterIndex)
    Reflect.defineMetadata(parameterIndex, name, target, propertyKey)
    Reflect.defineMetadata(DbUtil.getRawMetadataKey(parameterIndex), raw, target, propertyKey)
  }
}