import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:github_app/models/search_issues_response.dart';
import 'package:github_app/models/search_repositories_response.dart';
import 'package:github_app/models/search_users_response.dart';
import 'package:github_app/services/search_services.dart';

import 'bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  SearchState get initialState => SearchInitial();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is GetSearchRepositoriesEvent) {
      yield* _getSearchRepositories(event);
    } else if (event is GetSearchUsersEvent) {
      yield* _getSearchUsers(event);
    } else if (event is GetSearchIssuesEvent) {
      yield* _getSearchIssues(event);
    } else if (event is DoSwitchSortEvent) {
      yield* _doSwitchSort(event);
    }
  }

  Stream<SearchState> _getSearchRepositories(
      GetSearchRepositoriesEvent event) async* {
    yield SearchInitial();

    Map<String, dynamic> search = {
      'q': event.q.trim(),
      'per_page': event.perPage.trim(),
      'page': event.page.toString()
    };

    SearchRepositoriesResponse response;
    try {
      response = await getSearchRepositories(search);

      yield GetSearchRepositoriesSuccessState(
          result: response,
          page: event.page,
          q: event.q.trim(),
          type: event.type);
    } catch (err) {
      yield GetSearchRepositoriesFailedState(message: err.toString());
    }
  }

  Stream<SearchState> _getSearchUsers(GetSearchUsersEvent event) async* {
    yield SearchInitial();

    Map<String, dynamic> search = {
      'q': event.q.trim(),
      'per_page': event.perPage.trim(),
      'page': event.page.toString()
    };

    SearchUsersResponse response;
    try {
      response = await getUsersRepositories(search);

      yield GetSearchUsersSuccessState(
          result: response,
          page: event.page,
          q: event.q.trim(),
          type: event.type);
    } catch (err) {
      yield GetSearchUsersFailedState(message: err.toString());
    }
  }

  Stream<SearchState> _getSearchIssues(GetSearchIssuesEvent event) async* {
    yield SearchInitial();

    Map<String, dynamic> search = {
      'q': event.q.trim(),
      'per_page': event.perPage.trim(),
      'page': event.page.toString()
    };

    SearchIssuesResponse response;
    try {
      response = await getIssuesRepositories(search);

      yield GetSearchIssuesSuccessState(
          result: response,
          page: event.page,
          q: event.q.trim(),
          type: event.type);
    } catch (err) {
      yield GetSearchIssuesFailedState(message: err.toString());
    }
  }

  Stream<SearchState> _doSwitchSort(DoSwitchSortEvent event) async* {
    yield SearchInitial();

    yield DoSwitchSortState(api: event.api, type: event.type);
  }
}
