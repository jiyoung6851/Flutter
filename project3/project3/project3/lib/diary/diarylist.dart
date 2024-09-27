import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:project3/diary/diaryview.dart'; 

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

  // 댓글 리스트를 추가합니다.
  List<Map<String, dynamic>> comments = [];

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
      final response = await supabase
      .from('diary').select();

      if (response == null || response.isEmpty) {
        setState(() {
          _errorMessage = '데이터를 가져오지 못했습니다.';
        });
      } else {
        final diaries = response as List<dynamic>;
        diaries.shuffle(Random());
        for (var diary in diaries) {
          // 각 일기에 대한 댓글 수를 가져오기
          final commentResponse = await supabase
              .from('comment')
              .select()
              .eq('diary_id', diary['diary_id']);
          diary['comment_count'] = commentResponse.length; // 댓글 수 추가
        }
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

  Future<void> _updateLikeCount(String diaryId, int newLikeCount) async {
    try {
      await supabase
          .from('diary')
          .update({'diary_liked': newLikeCount})
          .eq('diary_id', diaryId)
          .select();
    } catch (e) {
      setState(() {
        _errorMessage = '데이터 업데이트 도중 오류가 발생했습니다: $e';
      });
    }
  }

  Future<void> _postComment(String diaryId, String commentContent) async {
    final userId = uuid.v4(); // 새로운 UUID 생성

    try {
      await supabase
          .from('comment')
          .insert({
            'diary_id': diaryId,
            'user_id': userId,
            'comment_content': commentContent,
            'comment_date': DateTime.now().toIso8601String(),
          })
          .select();
      await _fetchDiaries(); // 댓글 작성 후 일기 목록 갱신
    } catch (e) {
      print('댓글 게시 오류: $e');
    }
  }

void _showCommentDialog(String diaryId) {
  TextEditingController _commentController = TextEditingController();

  // 댓글을 가져오는 FutureBuilder를 포함한 다이얼로그
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 댓글 리스트
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchComments(diaryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('오류: ${snapshot.error}'));
                    } else {
                      final comments = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment['user_id'], style: TextStyle(fontWeight: FontWeight.bold)), // 작성자 ID
                                Text(comment['comment_content']), // 댓글 내용
                                Text(
                                  _formatCommentDate(comment['comment_date']), // 작성 시간
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // 댓글 입력 필드
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: '댓글을 입력하세요...',
                ),
                maxLines: 3,
              ),
            ],
          ),
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

              // 새로운 댓글 추가
              final newComment = {
                'user_id': 'test-user-id', // 여기서 작성자 ID를 설정
                'comment_content': commentContent,
                'comment_date': DateTime.now().toIso8601String(),
              };

              // 다이얼로그 내 댓글 리스트를 업데이트
              Navigator.of(context).pop(); // 다이얼로그 닫기
              _showCommentDialog(diaryId); // 다시 다이얼로그 열기
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

Future<List<Map<String, dynamic>>> _fetchComments(String diaryId) async {
  try {
    final response = await supabase
        .from('comment')
        .select()
        .eq('diary_id', diaryId)
        .order('comment_date', ascending: false); // 최신 댓글이 상단에 오도록 정렬

    return response.cast<Map<String, dynamic>>();
  } catch (e) {
    print('댓글 가져오기 오류: $e');
    return [];
  }
}

  String _formatCommentDate(String dateString) {
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
                    bool _liked = _likeCount % 2 != 0; // 좋아요 상태를 데이터에서 가져옴

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // diary_id와 diary_date를 위한 영역
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              color: Colors.transparent, // 카드 배경 없애기
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${diary['diary_id']}', // diary_id 출력
                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4.0), // 간격 추가
                                  Text(
                                    _formatDate(diary['diary_date'] ?? ''), // 작성 시간
                                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            // diary_content를 위한 영역
                            ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiaryViewPage(diary: diary),
                                    ),
                                  );
                                },
                                child: Text(
                                  diary['diary_content'] ?? '내용 없음',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            //   child: Align(
                            //     alignment: Alignment.bottomLeft,
                            //     child: Text(
                            //       _formatDate(diary['diary_date'] ?? ''),
                            //       style: const TextStyle(
                            //         color: Colors.grey,
                            //         fontSize: 14.0,
                            //         fontStyle: FontStyle.italic,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
                                              color: _liked ? Color.fromARGB(255, 248, 104, 52) : Color(0xFFFFAD8F),
                                            ),
                                            onPressed: () async {
                                              if (diary['diary_id'] != null) {
                                                int currentLikeCount = diary['diary_liked'] ?? 0;
                                                bool isLiked = currentLikeCount % 2 != 0;
                                                int newLikeCount = isLiked ? currentLikeCount - 1 : currentLikeCount + 1;

                                                setState(() {
                                                  _diaries[index]['diary_liked'] = newLikeCount;
                                                });

                                                try {
                                                  await _updateLikeCount(diary['diary_id'], newLikeCount);
                                                } catch (e) {
                                                  print('좋아요 업데이트 오류: $e');
                                                }
                                              }
                                            },
                                          ),
                                          Text(
                                            '${diary['diary_liked']}',
                                            style: const TextStyle(color: Color(0xFF333333)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.comment,
                                              color: Color(0xFFFFAD8F),
                                            ),
                                            onPressed: () {
                                              _showCommentDialog(diary['diary_id']);
                                            },
                                          ),
                                          Text(
                                            '${diary['comment_count']}', // 댓글 수 표시
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
}