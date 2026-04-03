import 'package:flutter/foundation.dart';

import '../data/event_model.dart';

enum EventsStatus { initial, loading, loaded, error }

enum EventDetailStatus { initial, loading, loaded, error }

enum EventFormStatus { initial, submitting, success, error }

@immutable
class EventsState {
  const EventsState({
    this.status = EventsStatus.initial,
    this.events = const [],
    this.errorMessage,
    this.selectedDate,
    this.isCalendarView = false,
    // Detail
    this.detailStatus = EventDetailStatus.initial,
    this.selectedEvent,
    this.detailError,
    // Form
    this.formStatus = EventFormStatus.initial,
    this.formError,
    // Attendance
    this.attendanceLoading = false,
  });

  final EventsStatus status;
  final List<EventModel> events;
  final String? errorMessage;
  final DateTime? selectedDate;
  final bool isCalendarView;

  final EventDetailStatus detailStatus;
  final EventModel? selectedEvent;
  final String? detailError;

  final EventFormStatus formStatus;
  final String? formError;

  final bool attendanceLoading;

  /// Events for calendar: group by date
  Map<DateTime, List<EventModel>> get eventsByDate {
    final map = <DateTime, List<EventModel>>{};
    for (final event in events) {
      if (event.date != null) {
        final key = DateTime(event.date!.year, event.date!.month, event.date!.day);
        map.putIfAbsent(key, () => []).add(event);
      }
    }
    return map;
  }

  /// Events filtered by selected date
  List<EventModel> get filteredEvents {
    if (selectedDate == null) return events;
    return events.where((e) {
      if (e.date == null) return false;
      return e.date!.year == selectedDate!.year &&
          e.date!.month == selectedDate!.month &&
          e.date!.day == selectedDate!.day;
    }).toList();
  }

  /// Events grouped by month for list view
  Map<String, List<EventModel>> get eventsByMonth {
    final map = <String, List<EventModel>>{};
    final months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    for (final event in events) {
      if (event.date != null) {
        final key = '${months[event.date!.month]} ${event.date!.year}';
        map.putIfAbsent(key, () => []).add(event);
      } else {
        map.putIfAbsent('بدون تاريخ', () => []).add(event);
      }
    }
    return map;
  }

  EventsState copyWith({
    EventsStatus? status,
    List<EventModel>? events,
    String? errorMessage,
    DateTime? selectedDate,
    bool? isCalendarView,
    EventDetailStatus? detailStatus,
    EventModel? selectedEvent,
    String? detailError,
    EventFormStatus? formStatus,
    String? formError,
    bool? attendanceLoading,
    bool clearError = false,
    bool clearDetailError = false,
    bool clearFormError = false,
    bool clearSelectedDate = false,
    bool clearSelectedEvent = false,
  }) {
    return EventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedDate:
          clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      isCalendarView: isCalendarView ?? this.isCalendarView,
      detailStatus: detailStatus ?? this.detailStatus,
      selectedEvent: clearSelectedEvent
          ? null
          : (selectedEvent ?? this.selectedEvent),
      detailError:
          clearDetailError ? null : (detailError ?? this.detailError),
      formStatus: formStatus ?? this.formStatus,
      formError: clearFormError ? null : (formError ?? this.formError),
      attendanceLoading: attendanceLoading ?? this.attendanceLoading,
    );
  }
}
