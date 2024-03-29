class DBBoxesAndCartonsOrderFieldData {
  int? box;
  int? xlCarton;
  int? lCarton;
  int? mCarton;
  int? sCarton;

  DBBoxesAndCartonsOrderFieldData(
      {this.box, this.xlCarton, this.lCarton, this.mCarton, this.sCarton});

  Map<String, int> toMap() {
    Map<String, int> map = {};

    if (box != null && box != 0) {
      map['box'] = box!;
    }
    if (xlCarton != null && xlCarton != 0) {
      map['xl_carton'] = xlCarton!;
    }
    if (lCarton != null && lCarton != 0) {
      map['l_carton'] = lCarton!;
    }
    if (mCarton != null && mCarton != 0) {
      map['m_carton'] = mCarton!;
    }
    if (sCarton != null && sCarton != 0) {
      map['s_carton'] = sCarton!;
    }

    return map;
  }

  factory DBBoxesAndCartonsOrderFieldData.fromMap(Map<String, dynamic> json) {
    int? box;
    int? xlCarton;
    int? lCarton;
    int? mCarton;
    int? sCarton;

    if (json.containsKey("box") && json["box"] is int) {
      box = json["box"]!;
    }
    if (json.containsKey("xl_carton") && json["xl_carton"] is int) {
      xlCarton = json["xl_carton"]!;
    }
    if (json.containsKey("l_carton") && json["l_carton"] is int) {
      lCarton = json["l_carton"]!;
    }
    if (json.containsKey("m_carton") && json["m_carton"] is int) {
      mCarton = json["m_carton"]!;
    }
    if (json.containsKey("s_carton") && json["s_carton"] is int) {
      sCarton = json["s_carton"]!;
    }

    return DBBoxesAndCartonsOrderFieldData(
        box: box,
        xlCarton: xlCarton,
        lCarton: lCarton,
        mCarton: mCarton,
        sCarton: sCarton);
  }
}
