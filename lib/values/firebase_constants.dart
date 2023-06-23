enum DefaultConstantsEnum {
  eggTypes,
}

class FirebaseConstants {
  static const defaultConstantsName = 'default_constants';
  static const defaultConstantsConstantName = 'constant_name';

  static const Map<DefaultConstantsEnum, String> defaultConstantsMap = {
    DefaultConstantsEnum.eggTypes: 'egg_types',
  };
}
