class Note {
  int _id;
  String _title;
  String _description;
  String _pathimage;
  String _date;
  int _color;

  int _ngay;
  int _thang;
  int _nam;
  int _gio;

  int get ngay => _ngay;

  set ngay(int value) {
    _ngay = value;
  }

  int _phut;
  int _thongbao;

  Note(this._title, this._pathimage, this._date, this._color, this._ngay,
      this._thang, this._nam, this._gio, this._phut, this._thongbao,
      [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get pathimage => _pathimage;
  String get date => _date;
  int get color => _color;

  set title(String newtitle) {
    this._title = newtitle;
  }

  set pathimage(String newpathimage) {
    _pathimage = newpathimage;
  }

  set description(String newdescription) {
    if (newdescription.length <= 800) this._description = newdescription;
  }

  set color(int newcolor) {
    if (newcolor >= 0 && newcolor <= 9) this._color = newcolor;
  }

  set date(String newdate) {
    this._date = newdate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['pathimage'] = _pathimage;
    map['date'] = _date;
    map['color'] = _color;

    map['ngay'] = _ngay;
    map['thang'] = _thang;
    map['nam'] = _nam;
    map['gio'] = _gio;
    map['phut'] = _phut;
    map['thongbao'] = _thongbao;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._pathimage = map['pathimage'];
    this._date = map['date'];
    this._color = map['color'];

    this._ngay = map['ngay'];
    this._thang = map['thang'];
    this._nam = map['nam'];
    this._gio = map['gio'];
    this._phut = map['phut'];
    this._thongbao = map['thongbao'];
  }

  int get thang => _thang;

  set thang(int value) {
    _thang = value;
  }

  int get nam => _nam;

  set nam(int value) {
    _nam = value;
  }

  int get gio => _gio;

  set gio(int value) {
    _gio = value;
  }

  int get phut => _phut;

  set phut(int value) {
    _phut = value;
  }

  int get thongbao => _thongbao;

  set thongbao(int value) {
    _thongbao = value;
  }
}
