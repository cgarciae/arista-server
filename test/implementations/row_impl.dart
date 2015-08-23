part of arista_server.implementations;


class RowImpl implements Row {
  RowImpl(this._columnNames, this._columnValues, this._index, this._columns) {
    assert(this._columnNames.length == this._columnValues.length);
  }

  factory RowImpl.fromMap (Map<String, Object> map) {
    var columnNames = map.keys.toList();
    var columnValues = map.values.toList();
    var index = {};

    for (var i in new Iterable.generate(columnNames.length))
    {
      index[new Symbol(columnNames[i])] = i;
    }

    var columns = null;

    return new RowImpl(columnNames, columnValues, index, columns);
  }

  // Map column name to column index
  final Map<Symbol, int> _index;
  final List<String> _columnNames;
  final List _columnValues;
  final List _columns;

  operator[] (int i) => _columnValues[i];

  void forEach(void f(String columnName, columnValue)) {
    assert(_columnValues.length == _columnNames.length);
    for (int i = 0; i < _columnValues.length; i++) {
      f(_columnNames[i], _columnValues[i]);
    }
  }

  noSuchMethod(Invocation invocation) {
    var name = invocation.memberName;
    if (invocation.isGetter) {
      var i = _index[name];
      if (i != null)
        return _columnValues[i];
    }
    super.noSuchMethod(invocation);
  }

  String toString() => _columnValues.toString();

  List toList() => new UnmodifiableListView(_columnValues);

  Map toMap() => new Map.fromIterables(_columnNames, _columnValues);

  List<Column> getColumns() => new UnmodifiableListView(_columns);

  static Stream<Row> streamFromMapList (List<Map> mapList) =>
  new Stream.fromIterable(mapList.map((map) => new RowImpl.fromMap(map)));
}