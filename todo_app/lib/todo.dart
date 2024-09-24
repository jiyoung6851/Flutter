class ToDo {
  final String title;

  ToDo({required this.title});

  // json 형식의 Map<String, dynamic> 타입으로 반환
  Map<String, dynamic> toJson() => {
        "title": title,
      };

  // factory: 새로운 인스턴스 생성하지 않는 생성자를 구현할때 사용
  // 일반 생성자와 다르게 return 존재
  factory ToDo.fromJson(Map<String, dynamic> json) {
    // 반환은 ToDo 객체(title로 json의 title에 해당하는 값을 가져옴)
    return ToDo(title: json["title"]);
  }
}
