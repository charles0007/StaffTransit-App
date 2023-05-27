class ValidateEmailModelResp {
  final String? email;
  final bool status;
  final String? error;

  ValidateEmailModelResp({required this.email,required this.status,required this.error});

  factory ValidateEmailModelResp.fromJson(Map<String, dynamic> json) {
    return ValidateEmailModelResp(
      email: json['email'],
      status: json['status'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'status':status,
      'error':error
    };
  }
}