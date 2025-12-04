enum EventPriority { low, medium, high }

class Event {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime datetime;
  final int durationMinutes;
  final EventPriority priority;
  final DateTime? createdAt;

  Event({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.datetime,
    this.durationMinutes = 60,
    this.priority = EventPriority.medium,
    this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      datetime: json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : DateTime.now(),
      durationMinutes: json['duration_minutes'] ?? 60,
      priority: _parsePriority(json['priority']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'event_date': datetime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'priority': priority.name,
    };
    
    // Only include optional fields if they have values
    if (id.isNotEmpty) json['id'] = id;
    if (userId.isNotEmpty) json['user_id'] = userId;
    if (description != null) json['description'] = description;
    if (createdAt != null) json['created_at'] = createdAt!.toIso8601String();
    
    return json;
  }

  static EventPriority _parsePriority(String? priority) {
    switch (priority) {
      case 'high':
        return EventPriority.high;
      case 'low':
        return EventPriority.low;
      default:
        return EventPriority.medium;
    }
  }

  String get priorityLabel {
    switch (priority) {
      case EventPriority.low:
        return 'Baixa';
      case EventPriority.medium:
        return 'Média';
      case EventPriority.high:
        return 'Alta';
    }
  }

  DateTime get endTime => datetime.add(Duration(minutes: durationMinutes));

  Event copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? datetime,
    int? durationMinutes,
    EventPriority? priority,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      datetime: datetime ?? this.datetime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
