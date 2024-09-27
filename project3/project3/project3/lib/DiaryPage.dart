import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 쓰기'),
      ),
      body: Center(
        child: Container(
          width: 768, // 고정된 너비
          height: 1500, // 고정된 높이
          decoration: BoxDecoration(
            color: Colors.white, // 흰색 배경
            border: Border.all(color: Colors.black, width: 1), // 테두리 추가
          ),
          child: Padding(
            padding: const EdgeInsets.all(50.0), // 전체 페이지에 여백 추가
            child: Column(
              children: [
                // 텍스트 입력 필드
                Expanded(
                  child: Container(
                    width: double.infinity, // 가로로 전체 너비 사용
                    padding: const EdgeInsets.all(16.0), // 텍스트 필드 주변에 여백 추가
                    decoration: BoxDecoration(
                      color: Colors.white, // 흰색 배경
                      border:
                          Border.all(color: Colors.black, width: 0.5), // 테두리 추가
                    ),
                    child: TextField(
                      maxLines: null, // 여러 줄 입력 가능
                      decoration: InputDecoration(
                        border: InputBorder.none, // 기본 테두리 제거
                        hintText: '여기서 일기를 작성하세요.',
                        hintStyle: const TextStyle(fontSize: 20.0),
                        contentPadding: EdgeInsets.zero, // 텍스트 필드 내부의 패딩 제거
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // 입력 필드와 아이콘 사이에 여백

                // 아이콘들
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround, // 아이콘들을 고르게 배치
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.photo_camera), // 사진 아이콘
                    //   iconSize: 40,
                    //   onPressed: () async {
                    //     // TODO: 사진 아이콘 클릭 시 동작
                    //     final ImagePicker Picker = ImagePicker();
                    //     final XFile? image =
                    //         await Picker.pickImage(source: ImageSource.gallery);

                    //     if (image != null) {
                    //       // 선택한 이미지 파일을 사용하여 필요한 동작을 수행
                    //       // 예를 들어, 이미지의 경로를 로그에 출력
                    //       print('Selected image path: ${image.path}');
                    //     }
                    //   },
                    // ),
                    IconButton(
                      icon: const Icon(Icons.video_camera_back), // 동영상 아이콘
                      iconSize: 40,
                      onPressed: () {
                        // TODO: 동영상 아이콘 클릭 시 동작
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.insert_emoticon), // 이모티콘 아이콘
                      iconSize: 40,
                      onPressed: () {
                        // TODO: 이모티콘 아이콘 클릭 시 동작
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16), // 아이콘들과 버튼 사이에 여백

                // 게시하기 버튼
                SizedBox(
                  width: 300,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      // 게시하기 버튼 클릭 시 동작
                      // TODO: 게시하기 기능 구현
                    },
                    child: const Text(
                      '게시하기',
                      style: TextStyle(fontSize: 20.0), // 버튼 텍스트 크기 조정
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
