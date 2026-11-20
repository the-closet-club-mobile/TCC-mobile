class SwapRequest {
  final int id;
  final int sender;
  final int recipient;
  final int offeredItem;
  final int requestedItem;
  final String status;

  SwapRequest({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.offeredItem,
    required this.requestedItem,
    required this.status,
  }); // Menutup constructor SwapRequest

  factory SwapRequest.fromJson(Map<String, dynamic> json) {
    return SwapRequest(
      id: json['id'],
      sender: json['sender'],
      recipient: json['recipient'],
      offeredItem: json['offered_item'],
      requestedItem: json['requested_item'],
      status: json['status'],
    );
  }
}