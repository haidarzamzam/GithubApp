import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetSearchRepositoriesEvent extends SearchEvent {
  final String q;
  final String perPage;
  final int page;
  final String type;

  GetSearchRepositoriesEvent({this.q, this.perPage, this.page, this.type});

  @override
  String toString() => 'GetSearchRepositoriesEvent';
}

class GetSearchUsersEvent extends SearchEvent {
  final String q;
  final String perPage;
  final int page;
  final String type;

  GetSearchUsersEvent({this.q, this.perPage, this.page, this.type});

  @override
  String toString() => 'GetSearchUsersEvent';
}

class GetSearchIssuesEvent extends SearchEvent {
  final String q;
  final String perPage;
  final int page;
  final String type;

  GetSearchIssuesEvent({this.q, this.perPage, this.page, this.type});

  @override
  String toString() => 'GetSearchIssuesEvent';
}

class DoSwitchSortEvent extends SearchEvent {
  final String api;
  final String type;

  DoSwitchSortEvent({this.api, this.type});

  @override
  String toString() => 'DoSwitchSortEvent';
}