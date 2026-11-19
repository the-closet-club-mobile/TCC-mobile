/// Today -> "14:05", otherwise -> "19/11".
String formatChatTime(DateTime time) {
  final local = time.toLocal();
  final now = DateTime.now();
  final sameDay =
      local.year == now.year && local.month == now.month && local.day == now.day;
  if (sameDay) return formatClock(local);
  return '${local.day}/${local.month}';
}

String formatClock(DateTime time) {
  final local = time.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}