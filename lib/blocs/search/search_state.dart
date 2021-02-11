import 'package:equatable/equatable.dart';
import 'package:github_app/models/search_issues_response.dart';
import 'package:github_app/models/search_repositories_response.dart';
import 'package:github_app/models/search_users_response.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class GetSearchRepositoriesSuccessState extends SearchState {
  final SearchRepositoriesResponse result;
  final int page;

  GetSearchRepositoriesSuccessState({this.result, this.page});
}

class GetSearchRepositoriesFailedState extends SearchState {
  final String message;

  GetSearchRepositoriesFailedState({this.message});
}

class GetSearchUsersSuccessState extends SearchState {
  final SearchUsersResponse result;
  final int page;

  GetSearchUsersSuccessState({this.result, this.page});
}

class GetSearchUsersFailedState extends SearchState {
  final String message;

  GetSearchUsersFailedState({this.message});
}

class GetSearchIssuesSuccessState extends SearchState {
  final SearchIssuesResponse result;
  final int page;

  GetSearchIssuesSuccessState({this.result, this.page});
}

class GetSearchIssuesFailedState extends SearchState {
  final String message;

  GetSearchIssuesFailedState({this.message});
}
