import 'package:flutter/material.dart';

// 초록색 강조 색상 재사용
const Color _kAccentColor = Color(0xFF6DEDC2);

// 채팅방 화면 위젯
class ChatRoomScreen extends StatefulWidget {
  final String chatPartnerNickname;

  const ChatRoomScreen({super.key, required this.chatPartnerNickname});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  // 사용자의 메시지를 저장할 리스트 (더미 데이터)
  final List<Map<String, dynamic>> _messages = [];
  // 메시지 입력 컨트롤러
  final TextEditingController _textController = TextEditingController();
  // 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 초기 더미 메시지 추가 (선택사항)
    _messages.addAll([
      {'text': '화이팅~~', 'isMine': false, 'time': '오후 2:30'},
      {'text': '지금부터 하겠습니다!!', 'isMine': true, 'time': '오후 2:31'},
      {'text': '과제는 다 했나요?', 'isMine': false, 'time': '오후 2:31'},
    ]);
  }

  // 메시지 전송 처리 함수
  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return; // 빈 메시지는 전송하지 않음

    // 입력 필드 초기화
    _textController.clear();

    // 메시지 리스트에 추가하고 UI 업데이트
    setState(() {
      _messages.insert(0, {
        'text': text,
        'isMine': true,
        'time': _getCurrentTime(),
      });
    });

    // 메시지를 전송한 후, 키보드가 닫히고 스크롤이 자동으로 이동하도록
    FocusScope.of(context).unfocus();
  }

  // 현재 시간을 문자열로 반환
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? '오후' : '오전';
    return '$period ${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // 개별 메시지를 표시하는 위젯
  Widget _buildMessage(Map<String, dynamic> message) {
    final isMine = message['isMine'] as bool;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 내 메시지일 때 시간을 왼쪽에 표시
          if (isMine) ...[
            Padding(
              padding: const EdgeInsets.only(right: 6.0, bottom: 2.0),
              child: Text(
                message['time'],
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ),
          ],
          // 메시지 버블
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 14.0,
              ),
              decoration: BoxDecoration(
                color: isMine ? _kAccentColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(18.0).copyWith(
                  topRight: isMine ? const Radius.circular(4) : null,
                  topLeft: !isMine ? const Radius.circular(4) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: isMine ? Colors.black87 : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
          // 상대방 메시지일 때 시간을 오른쪽에 표시
          if (!isMine) ...[
            Padding(
              padding: const EdgeInsets.only(left: 6.0, bottom: 2.0),
              child: Text(
                message['time'],
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 메시지 입력 필드와 전송 버튼
  Widget _buildTextComposer() {
    return Container(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: MediaQuery.of(context).padding.bottom + 8.0,
        top: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                maxLines: null,
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration.collapsed(
                  hintText: "메시지를 입력하세요...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: _kAccentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _kAccentColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, size: 20),
              color: Colors.black87,
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _kAccentColor.withOpacity(0.3),
              child: Text(
                widget.chatPartnerNickname[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.chatPartnerNickname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '온라인',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        centerTitle: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              reverse: true,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
