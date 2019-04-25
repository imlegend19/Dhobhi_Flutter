abstract class APIStatic {
  static const keyID = "id";
  static const keyCount = "count";
  static const keyNext = "next";
  static const keyPrevious = "previous";
  static const keyResults = "results";

  static const baseURL = "http://13.233.179.130/api/";
}

abstract class CirculationStatic {
  static const keyCheckInDate = "check_in_date";
  static const keyCardNo = "card_no";
  static const keyClothes = "clothes";

  static const keyCheckOutDate = "check_out_date";

  static const keyCheckInURL = APIStatic.baseURL + "circulation/check-in/";
  static const keyCheckOutURL = APIStatic.baseURL + "circulation/check-out/";
}

abstract class Student {
  static const keyERP = "erp";
  static const keyRegistered = "registered";
}