import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserModel {
  Timestamp createdAt = Timestamp.now();
  String reportByUserEmail = '';
  String reportByUserID = '';
  String reportByUserName = '';

  String userReportedEmail = '';
  String userReportedID = '';
  String userReportedName = '';

  String content = '';
  String status = '';

  ReportUserModel(
      {this.createdAt,
      this.reportByUserEmail,
      this.reportByUserID,
      this.reportByUserName,
      this.userReportedEmail,
      this.userReportedID,
      this.userReportedName,
      this.content,
      this.status});

  factory ReportUserModel.fromJson(Map<String, dynamic> parsedJson) {
    return ReportUserModel(
        createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
        reportByUserEmail: parsedJson['reportByUserEmail'] ?? '',
        reportByUserID: parsedJson['reportByUserID'] ?? '',
        reportByUserName: parsedJson['reportByUserName'] ?? '',
        userReportedEmail: parsedJson['userReportedEmail'] ?? '',
        userReportedID: parsedJson['userReportedID'] ?? '',
        userReportedName: parsedJson['userReportedName'] ?? '',
        content: parsedJson['content'] ?? '',
        status: parsedJson['status'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'reportByUserEmail': reportByUserEmail,
      'reportByUser': reportByUserID,
      'reportByUserName': reportByUserName,
      'userReportedEmail': userReportedEmail,
      'userReported': userReportedID,
      'userReportedName': userReportedName,
      'content': content,
      'status': status
    };
  }
}
