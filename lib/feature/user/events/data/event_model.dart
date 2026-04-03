import 'package:flutter/foundation.dart';

@immutable
class EventStatistics {
  const EventStatistics({
    this.total = 0,
    this.attending = 0,
    this.notAttending = 0,
    this.pending = 0,
  });

  final int total;
  final int attending;
  final int notAttending;
  final int pending;

  factory EventStatistics.fromJson(Map<String, dynamic> json) {
    return EventStatistics(
      total: (json['total'] as num?)?.toInt() ?? 0,
      attending: (json['attending'] as num?)?.toInt() ?? 0,
      notAttending: (json['not_attending'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
    );
  }
}

@immutable
class EventAttendee {
  const EventAttendee({
    required this.id,
    required this.name,
    this.gender,
    this.phone,
    this.nationalId,
    this.dateOfBirth,
    this.city,
    this.imageUrl,
    this.branchName,
    this.fatherName,
    this.dead = false,
  });

  final int id;
  final String name;
  final String? gender;
  final String? phone;
  final String? nationalId;
  final String? dateOfBirth;
  final String? city;
  final String? imageUrl;
  final String? branchName;
  final String? fatherName;
  final bool dead;

  factory EventAttendee.fromJson(Map<String, dynamic> json) {
    final branch = json['branch'];
    final father = json['father'];
    return EventAttendee(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      city: json['city']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      branchName:
          branch is Map<String, dynamic> ? branch['name']?.toString() : null,
      fatherName:
          father is Map<String, dynamic> ? father['name']?.toString() : null,
      dead: json['dead'] == true,
    );
  }
}

@immutable
class EventModel {
  const EventModel({
    required this.id,
    required this.name,
    this.description,
    this.date,
    this.time,
    this.location,
    this.type,
    this.active = true,
    this.createdAt,
    this.myAttendance,
    this.statistics = const EventStatistics(),
    this.attendees = const [],
  });

  final int id;
  final String name;
  final String? description;
  final DateTime? date;
  final String? time;
  final String? location;
  final String? type;
  final bool active;
  final DateTime? createdAt;
  final String? myAttendance;
  final EventStatistics statistics;
  final List<EventAttendee> attendees;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final rawAttendees = json['attendees'];
    final attendeeList = <EventAttendee>[];
    if (rawAttendees is List) {
      for (final item in rawAttendees) {
        if (item is Map<String, dynamic>) {
          attendeeList.add(EventAttendee.fromJson(item));
        }
      }
    }

    EventStatistics stats = const EventStatistics();
    if (json['statistics'] is Map<String, dynamic>) {
      stats = EventStatistics.fromJson(json['statistics'] as Map<String, dynamic>);
    }

    return EventModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      time: json['time']?.toString(),
      location: json['location']?.toString(),
      type: json['type']?.toString(),
      active: json['active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      myAttendance: json['my_attendance']?.toString(),
      statistics: stats,
      attendees: attendeeList,
    );
  }

  EventModel copyWith({
    String? myAttendance,
    EventStatistics? statistics,
    List<EventAttendee>? attendees,
  }) {
    return EventModel(
      id: id,
      name: name,
      description: description,
      date: date,
      time: time,
      location: location,
      type: type,
      active: active,
      createdAt: createdAt,
      myAttendance: myAttendance ?? this.myAttendance,
      statistics: statistics ?? this.statistics,
      attendees: attendees ?? this.attendees,
    );
  }
}
