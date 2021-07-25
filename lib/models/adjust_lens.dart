class AdjustLens {
  static const SPH = "sph";
  static const CYL = "cyl";
  static const AXIS = "axis";
  static const ADD = "add";

  // Private Variabel
  String _sph;
  String _cyl;
  String _axis;
  String _add;

//Getter read only, private variabel
  String get sph => _sph;
  String get cyl => _cyl;
  String get axis => _axis;
  String get add => _add;


  AdjustLens.fromMap(Map data){
    _sph = data[SPH];
    _cyl =  data[CYL];
    _axis =  data[AXIS];
    _add = data[ADD];
  }

// buat convert ke map
  Map toMap() => {
    SPH: _sph,
    CYL: _cyl,
    AXIS: _axis,
    ADD: _add,
  };
}