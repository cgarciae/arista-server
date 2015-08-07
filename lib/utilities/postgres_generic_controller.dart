part of arista_server.utilities;

class PostgresController<T> extends PostgreSqlService<T> {
  final String tableName;

  PostgresController(this.tableName, PostgreSql conn)
      : super.fromConnection(conn);

  Future<List<T>> find ({String condition, values: const {}}) {
    return query("""
      SELECT * FROM "$tableName"
      ${condition != null? "WHERE $condition": ""}
    """, values);
  }

  Future<T> findByPrimaryKey(String keyName, keyValue) async {
    List<T> list = await query("""
      SELECT * FROM "$tableName"
      WHERE "$keyName" = @$keyName
      LIMIT 1
    """, {keyName: keyValue});

    return list.first;
  }

  Future insert(T obj, {correctMap(DynamicMap map)}) {
    var fieldStructure = _fieldStructure(obj);
    var valueStructure = _valueStructure(obj);
    var map = new DynamicMap(encode(obj));

    if (correctMap != null) {
      correctMap(map);
    }

    return query("""
      INSERT INTO $tableName $fieldStructure
        VALUES $valueStructure;
    """, map);
  }

  Future updateOnKey(T delta, String keyName, keyValue) {
    var fields = _fieldStructure(delta);
    var values = _valueStructure(delta);

    Map valuesMap = encode(delta);
    valuesMap[keyName] = keyValue;

    return query("""
      UPDATE $tableName
        SET $fields = $values
      WHERE "$keyName" = @$keyName
      """, valuesMap);
  }

  Future updateOnCondition(T delta, String whereCondition) {
    var fields = _fieldStructure(delta);
    var values = _valueStructure(delta);

    return query("""
      UPDATE $tableName
        SET $fields = $values
      WHERE $whereCondition
      """, delta);
  }

  Future deleteOnKey(String keyName, keyValue) {

    print(keyValue);

    return query("""
      DELETE FROM $tableName
      WHERE "$keyName" = @$keyName
      """, {keyName: keyValue});
  }

  Future deleteOnCondition(T obj, String whereCondition) {

    return query("""
      DELETE FROM $tableName
      WHERE $whereCondition
      """, obj);
  }

  String _fieldStructure(T obj) {
    Map userMap = encode(obj);
    List<String> modKeys = userMap.keys.map((s) => '"$s"').toList();
    String structure = '(' + modKeys.join(',') + ')';
    return structure;
  }

  String _valueStructure(T obj) {
    Map userMap = encode(obj);
    String values = '(' + userMap.keys.map((s) => "@$s").join(',') + ')';
    return values;
  }
}
