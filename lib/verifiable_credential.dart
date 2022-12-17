class VerifiableCredential {
  final String uid;
  final String content;
  final String type;

  VerifiableCredential(this.uid, this.content, this.type);

  VerifiableCredential.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        type = json['type'],
        content = json['content'];

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'content': content, 'type': type};
}
