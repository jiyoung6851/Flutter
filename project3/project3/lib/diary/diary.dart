import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'diaryview.dart';  // DiaryViewPage import

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _emoticons = [
    '😀', '😂', '😍', '🥺', '😎', '🥳', '😜', '😢', '😅', '🙄', '😡', '🤔'
  ];

  Future<void> _launchYouTube() async {
    const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'; // 대체할 유튜브 URL
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e'); // 오류 메시지를 출력
    }
  }

  void _showEmoticonPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이모티콘 선택'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _emoticons.map((emoticon) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _textController.text += emoticon;
                    });
                  },
                  child: Text(
                    emoticon,
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _postDiary() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('diary')
          .insert({
            'diary_content': _textController.text,
            'diary_date': DateTime.now().toIso8601String(),
            'diary_image': null,
            'diary_hit': 0,
            'diary_liked': 0,
          })
          .select(); // 데이터를 반환받기 위해 select() 사용

      if (response.isEmpty) {
        print('데이터가 반환되지 않았습니다.');
      } else {
        print('일기가 성공적으로 게시되었습니다.');

        final insertedDiary = response[0];
        _textController.clear();

        // 작성 완료 알림
        _showCompletionDialog(insertedDiary);
      }
    } catch (e) {
      if (e is PostgrestException) {
        print('일기 게시 오류: ${e.message}');
      } else {
        print('예외 발생: $e');
      }
    }
  }

  void _showCompletionDialog(Map<String, dynamic> diary) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('작성완료'),
          content: const Text('일기가 성공적으로 게시되었습니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 알림 창 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryViewPage(diary: diary),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 쓰기'),
      ),
      body: Center(
        child: Container(
          width: 768,
          height: 1500,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '오늘 하루 무슨 일이 있었나요?',
                        hintStyle: const TextStyle(fontSize: 20.0),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_camera),
                      iconSize: 40,
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          print('Selected image path: ${image.path}');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.video_camera_back),
                      iconSize: 40,
                      onPressed: _launchYouTube,
                    ),
                    IconButton(
                      icon: const Icon(Icons.insert_emoticon),
                      iconSize: 40,
                      onPressed: _showEmoticonPicker,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: 300,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: _postDiary,
                    child: const Text(
                      '게시하기',
                      style: TextStyle(fontSize: 20.0),
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
