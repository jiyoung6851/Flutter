// 로컬 저장소에 간단한 데이터 저장하고 불러오는 기능
import 'package:shared_preferences/shared_preferences.dart';
// json 데이터를 인코딩 or 디코딩
import 'dart:convert';
// 만들어 놓은거 사용
import 'todo.dart';

class LocalStorage {
  // ToDo 리스트 저장할 때 사용할 키 값
  static const _keyToDos = "todos";

  // Future 비동기 타입(로컬에 저장된 ToDo 리스트를 불러옴)
  Future<List<ToDo>> readToDos() async {
    // await: async 사용할때 메소드에서 사용
    final prefs = await SharedPreferences.getInstance();
    // _keyToDos에 저장된 문자열을 가져옴
    final todosString = prefs.getString(_keyToDos);

    //널이면 빈 리스트를 반환
    if (todosString == null) {
      return [];
    }
    // todosString 을 json 문자열로 디코딩
    // dynamic: 런타임일때 타입이 결정됨
    List<dynamic> jsonData = jsonDecode(todosString);

    // jsonData 를 ToDo 객체로 변환해서 리스트로 반환
    return jsonData.map((json) => ToDo.fromJson(json)).toList();
  }

  //ToDo 리스트를 로컬 저장소에 저장
  Future<void> wirteToDos(List<ToDo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    // ToDo 객체를 json 형식으로 변환하고 json으로 인코딩
    String json = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    // 키와 json 데이터를 로컬 저장소에 저장
    await prefs.setString(_keyToDos, json);
  }
}
