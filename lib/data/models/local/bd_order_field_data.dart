class DBOrderFieldData {

  num? xlBoxPrice;
  late num xlBoxQuantity;
  num? xlDozenPrice;
  late num xlDozenQuantity;

  num? lBoxPrice;
  late num lBoxQuantity;
  num? lDozenPrice;
  late num lDozenQuantity;

  num? mBoxPrice;
  late num mBoxQuantity;
  num? mDozenPrice;
  late num mDozenQuantity;

  num? sBoxPrice;
  late num sBoxQuantity;
  num? sDozenPrice;
  late num sDozenQuantity;

  DBOrderFieldData({
    xlBoxPrice,
    xlBoxQuantity = 0,
    xlDozenPrice,
    xlDozenQuantity = 0,

    lBoxPrice,
    lBoxQuantity = 0,
    lDozenPrice,
    lDozenQuantity = 0,

    mBoxPrice,
    mBoxQuantity = 0,
    mDozenPrice,
    mDozenQuantity = 0,

    sBoxPrice,
    sBoxQuantity = 0,
    sDozenPrice,
    sDozenQuantity = 0,
  });

}
