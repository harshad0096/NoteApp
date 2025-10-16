class Notesmodel {
  final String Title;
  final String Description;

  Notesmodel({required this.Title, required this.Description});

  
  factory Notesmodel.fromJson(Map<String, dynamic> json) {
    return Notesmodel(
      Title: json['Title'] as String,
      Description: json['Description'] as String,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {'Title': Title, 'Description': Description};
  }
}
