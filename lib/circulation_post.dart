import 'dart:convert';

class CheckInPost {
  String cardNumber;
  String clothes;

  CheckInPost({this.cardNumber, this.clothes});

  factory CheckInPost.fromJson(Map<String, dynamic> json) => CheckInPost(
        cardNumber: json["card_no"],
        clothes: json["clothes"],
      );

  Map<String, dynamic> toJson() => {"card_no": cardNumber, "clothes": clothes};
}

String postCheckInToJson(CheckInPost data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CheckOutPost {
  String cardNumber;

  CheckOutPost({this.cardNumber});

  factory CheckOutPost.fromJson(Map<String, dynamic> json) => CheckOutPost(
    cardNumber: json["card_no"]
  );

  Map<String, dynamic> toJson() => {"card_no": cardNumber};
}

String postCheckOutToJson(CheckOutPost data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}