class Task {
  String? idLocal;
  String? id;
  String title;
  String description;
  bool isCompleted;
  String? userId;
  bool isModified;
  bool isSynced;
  bool isDeleted;

  Task({
    this.idLocal,
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.userId,
    this.isModified = false,
    this.isSynced = false,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  Map<String, dynamic> toFullMap() {
    return {
      'idLocal': idLocal,
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'userId': userId,
      'isModified': isModified,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      idLocal: map['idLocal'],
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      userId: map['userId'],
      isModified: map['isModified'] ?? false,
      isSynced: map['isSynced'],
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  Task copyWith({
    String? idLocal,
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? userId,
    bool? isModified,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Task(
      idLocal: idLocal ?? this.idLocal,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      isModified: isModified ?? this.isModified,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
