part of arista_server.utilities;

class PostgresController<T> extends PostgreSqlService<T> {
  final String tableName;
  final String primaryKeyName;

  PostgresController(this.tableName, this.primaryKeyName, PostgreSql conn)
      : super.fromConnection(conn);

  Future<List<T>> find ({String condition, values: const {}}) {
    return query("""
      SELECT * FROM "$tableName"
      ${condition != null? "WHERE $condition": ""}
    """, values);
  }

  Future<T> findOne ({String condition, values: const {}}) async {
    var list = await query("""
      SELECT * FROM "$tableName"
      ${condition != null? "WHERE $condition": ""}
      LIMIT 1
    """, values);
    try {
      return list.first;
    }
    catch (e) {
      return null;
    }
  }


  Future<T> findByPrimaryKey(keyValue) async {
    List<T> list = await query("""
      SELECT * FROM "$tableName"
      WHERE "$primaryKeyName" = @$primaryKeyName
      LIMIT 1
    """, {primaryKeyName: keyValue});

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

  Future updateOnPrimaryKey(T delta, keyValue) {
    var fields = _fieldStructure(delta);
    var values = _valueStructure(delta);

    Map valuesMap = encode(delta);
    valuesMap[primaryKeyName] = keyValue;

    return query("""
      UPDATE $tableName
        SET $fields = $values
      WHERE "$primaryKeyName" = @$primaryKeyName
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

  Future deleteOnPrimaryKey(keyValue) {

    return query("""
      DELETE FROM $tableName
      WHERE "$primaryKeyName" = @$primaryKeyName
      """, {primaryKeyName: keyValue});
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
