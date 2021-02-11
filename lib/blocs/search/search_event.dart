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

  GetSearchRepositoriesEvent({this.q, this.perPage, this.page});

  @override
  String toString() => 'GetSearchRepositoriesEvent';
}

class GetSearchUsersEvent extends SearchEvent {
  final String q;
  final String perPage;
  final int page;

  GetSearchUsersEvent({this.q, this.perPage, this.page});

  @override
  String toString() => 'GetSearchUsersEvent';
}

class GetSearchIssuesEvent extends SearchEvent {
  final String q;
  final String perPage;
  final int page;

  GetSearchIssuesEvent({this.q, this.perPage, this.page});

  @override
  String toString() => 'GetSearchIssuesEvent';
}
