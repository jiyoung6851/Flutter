import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'diaryview.dart'; // 새로운 페이지 임포트
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class DiaryListPage extends StatefulWidget {
  const DiaryListPage({super.key});

  @override
  _DiaryListPageState createState() => _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _diaries = [];
  List<Map<String, dynamic>> _comments = [];
  bool _loading = true;
  String _errorMessage = '';

    // 테스트용 user_id 설정
  final String _testUserId = 'test-user-id'; // 여기에 테스트할 user_id를 설정

  @override
  void initState() {
    super.initState();
    _fetchDiaries();
  }

Future<void> _fetchDiaries() async {
  setState(() {
    _loading = true;
  });

  try {
    final response = await supabase.from('diary').select();

    if (response == null || response.isEmpty) {
      setState(() {
        _errorMessage = '데이터를 가져오지 못했습니다.';
      });
    } else {
      final diaries = response as List<dynamic>;
      diaries.shuffle(Random());
      setState(() {
        _diaries = diaries.cast<Map<String, dynamic>>();
        _errorMessage = '';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = '데이터를 가져오는 도중 오류가 발생했습니다: $e';
    });
  } finally {
    setState(() {
      _loading = false;
    });
  }
}
  Future<void> _fetchComments(String diaryId) async {
    try {
      final response = await supabase
          .from('comment')
          .select()
          .eq('diary_id', diaryId);

      if (response != null && response.isNotEmpty) {
        setState(() {
          _comments = response.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('댓글 가져오기 오류: $e');
    }
  }

  Future<void> _updateLikeCount(String diaryId, int newLikeCount) async {

  try {
    // 좋아요 수를 업데이트하고, 업데이트된 데이터를 반환
    final response = await supabase
      .from('diary')
      .update({
        'diary_liked': newLikeCount
      })
      .eq('diary_id', diaryId)
      .select(); // 업데이트 후 새로운 데이터를 선택하여 반환

    if (response == null || response.isEmpty) {
      setState(() {
        _errorMessage = '데이터 업데이트 도중 오류가 발생했습니다.';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = '데이터 업데이트 도중 오류가 발생했습니다: $e';
    });
  }
}

  Future<void> _postComment(String diaryId, String commentContent) async {
    final supabase = Supabase.instance.client;

    // 임의의 UUID를 생성합니다.
    final userId = uuid.v4(); // 새로운 UUID 생성

  try {
    // 테스트용 user_id를 사용하여 comment 테이블에 새로운 댓글 삽입
    final response = await supabase
        .from('comment')
        .insert({
          'diary_id': diaryId,
          'user_id': userId,    // 생성한 UUID 사용
          'comment_content': commentContent,
          'comment_date': DateTime.now().toIso8601String(),
        })
        .select();

      if (response.isEmpty) {
        print('댓글 작성 실패.');
      } else {
        print('댓글 작성 성공.');
      }
    } catch (e) {
      print('댓글 게시 오류: $e');
    }
  }

  void _showCommentDialog(String diaryId) {
    TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('댓글 작성'),
          content: TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: '댓글을 입력하세요...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('게시'),
              onPressed: () async {
                final commentContent = _commentController.text.trim();
                if (commentContent.isNotEmpty) {
                  await _postComment(diaryId, commentContent);
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                } else {
                  print('댓글 내용이 비어 있습니다.');
                }
              },
            ),
          ],
        );
      },
    );
  }


  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else {
      return '방금 전';
    }
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 목록'),
        backgroundColor: const Color(0xFFFFAD8F),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('오류: $_errorMessage'))
              : ListView.builder(
                  itemCount: _diaries.length,
                  itemBuilder: (context, index) {
                    final diary = _diaries[index];
                    int _likeCount = diary['diary_liked'] ?? 0; // 좋아요 카운트를 데이터에서 가져옴
                    bool _liked =  _likeCount % 2 != 0; // 좋아요 상태를 데이터에서 가져옴

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        width: double.infinity, // 카드 넓이 조정
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                diary['diary_content'] ?? '내용 없음',
                                maxLines: 4, // 더 많은 텍스트를 보여주기 위해 늘린 라인 수
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiaryViewPage(diary: diary),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  _formatDate(diary['diary_date'] ?? ''),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [

                                          IconButton(
                                            icon: Icon(
                                              Icons.thumb_up,
                                              color:  _liked ? Color.fromARGB(255, 248, 104, 52) : Color(0xFFFFAD8F),
                                            ),
                                            onPressed: () async {
                                              // diary_ID가 null인지 체크
                                              if (diary['diary_id'] != null) {
                                                int currentLikeCount = diary['diary_liked'] ?? 0; // 현재 좋아요 수
                                                bool isLiked = currentLikeCount % 2 != 0;
                                                // 좋아요 상태와 카운트 업데이트
                                                int newLikeCount = isLiked ? currentLikeCount - 1 : currentLikeCount + 1;

                                                  //먼제 UI 상태를 즉시 업데이트
                                                  setState(() {
                                                    _diaries[index]['diary_liked'] = newLikeCount; // UI 상의 좋아요 수 업데이트
                                                  });

                                                try{
                                                  await _updateLikeCount(diary['diary_id'], newLikeCount);
                                                } catch (e) {
                                                  // 에러 발생 시 이전 상태로 복구
                                                  setState(() {
                                                    _diaries[index]['diary_liked'] = currentLikeCount;
                                                    _errorMessage = '좋아요 처리 도중 오류 발생';
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                          Text(
                                            '${diary['diary_liked']}', // 좋아요 수 업데이트
                                            style: const TextStyle(color: Color(0xFF333333)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0), // 좋아요와 댓글 간의 간격
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.comment,
                                              color: Color(0xFFFFAD8F),
                                            ),
                                            onPressed: () {
                                              // 댓글쓰기 버튼 클릭 시 동작 추가
                                                if (diary['diary_id'] != null) {
                                                _showCommentDialog(diary['diary_id']);
                                              }
                                            },
                                          ),
                                          Text(
                                            '25', // 댓글 수 (예시)
                                            style: const TextStyle(color: Color(0xFF333333)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
