import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/events_remote_data_source.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit(this._remote) : super(const EventsState());

  final EventsRemoteDataSource _remote;

  /// Load all events
  Future<void> loadEvents() async {
    emit(state.copyWith(status: EventsStatus.loading, clearError: true));
    try {
      final events = await _remote.fetchEvents();
      emit(state.copyWith(status: EventsStatus.loaded, events: events));
    } catch (e) {
      emit(state.copyWith(
        status: EventsStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Toggle between list and calendar view
  void toggleView() {
    emit(state.copyWith(isCalendarView: !state.isCalendarView));
  }

  /// Select a date in calendar view
  void selectDate(DateTime date) {
    // If same date, deselect
    if (state.selectedDate != null &&
        state.selectedDate!.year == date.year &&
        state.selectedDate!.month == date.month &&
        state.selectedDate!.day == date.day) {
      emit(state.copyWith(clearSelectedDate: true));
    } else {
      emit(state.copyWith(selectedDate: date));
    }
  }

  /// Load event details
  Future<void> loadEventDetails(int eventId) async {
    emit(state.copyWith(
      detailStatus: EventDetailStatus.loading,
      clearDetailError: true,
      clearSelectedEvent: true,
    ));
    try {
      final event = await _remote.fetchEventDetails(eventId);
      emit(state.copyWith(
        detailStatus: EventDetailStatus.loaded,
        selectedEvent: event,
      ));
    } catch (e) {
      emit(state.copyWith(
        detailStatus: EventDetailStatus.error,
        detailError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Create a new event
  Future<void> createEvent({
    required String name,
    required String description,
    required String date,
    required String time,
    required String location,
    String? lat,
    String? lng,
  }) async {
    emit(state.copyWith(formStatus: EventFormStatus.submitting, clearFormError: true));
    try {
      await _remote.createEvent(
        name: name,
        description: description,
        date: date,
        time: time,
        location: location,
        lat: lat,
        lng: lng,
      );
      emit(state.copyWith(formStatus: EventFormStatus.success));
      // Refresh list
      await loadEvents();
    } catch (e) {
      emit(state.copyWith(
        formStatus: EventFormStatus.error,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Update an existing event
  Future<void> updateEvent({
    required int eventId,
    required String name,
    required String description,
    required String date,
    required String time,
    required String location,
    String? lat,
    String? lng,
  }) async {
    emit(state.copyWith(formStatus: EventFormStatus.submitting, clearFormError: true));
    try {
      await _remote.updateEvent(
        eventId: eventId,
        name: name,
        description: description,
        date: date,
        time: time,
        location: location,
        lat: lat,
        lng: lng,
      );
      emit(state.copyWith(formStatus: EventFormStatus.success));
      await loadEvents();
    } catch (e) {
      emit(state.copyWith(
        formStatus: EventFormStatus.error,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Delete event
  Future<void> deleteEvent(int eventId) async {
    try {
      await _remote.deleteEvents([eventId]);
      await loadEvents();
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Record attendance
  Future<void> recordAttendance({
    required int eventId,
    required String status,
    String? note,
  }) async {
    emit(state.copyWith(attendanceLoading: true));
    try {
      await _remote.recordAttendance(
        eventId: eventId,
        status: status,
        note: note,
      );
      // Refresh event details
      await loadEventDetails(eventId);
      emit(state.copyWith(attendanceLoading: false));
    } catch (e) {
      emit(state.copyWith(
        attendanceLoading: false,
        detailError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Reset form state
  void resetFormState() {
    emit(state.copyWith(
      formStatus: EventFormStatus.initial,
      clearFormError: true,
    ));
  }
}
