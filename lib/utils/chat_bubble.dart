import '../barrel/export.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTimeString(timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       color: Colors.blue,
  //     ),
  //     child: Text(
  //       message,
  //       style: TextStyle(
  //         fontSize: 16,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );

  String getTimeString(DateTime time) {
    final format = DateFormat.jm(); // Format the time as HH:MM AM/PM
    return format.format(time);
  }
}
