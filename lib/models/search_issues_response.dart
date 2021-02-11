class SearchIssuesResponse {
  int totalCount;
  bool incompleteResults;
  List<Items> items;

  SearchIssuesResponse({this.totalCount, this.incompleteResults, this.items});

  SearchIssuesResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    incompleteResults = json['incomplete_results'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['incomplete_results'] = this.incompleteResults;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String url;
  String repositoryUrl;
  String labelsUrl;
  String commentsUrl;
  String eventsUrl;
  String htmlUrl;
  int id;
  String nodeId;
  int number;
  String title;
  User user;
  List<Null> labels;
  String state;
  bool locked;
  Null assignee;
  List<Null> assignees;
  Null milestone;
  int comments;
  String createdAt;
  String updatedAt;
  Null closedAt;
  String authorAssociation;
  Null activeLockReason;
  bool draft;
  PullRequest pullRequest;
  String body;
  Null performedViaGithubApp;
  int score;

  Items(
      {this.url,
      this.repositoryUrl,
      this.labelsUrl,
      this.commentsUrl,
      this.eventsUrl,
      this.htmlUrl,
      this.id,
      this.nodeId,
      this.number,
      this.title,
      this.user,
      this.labels,
      this.state,
      this.locked,
      this.assignee,
      this.assignees,
      this.milestone,
      this.comments,
      this.createdAt,
      this.updatedAt,
      this.closedAt,
      this.authorAssociation,
      this.activeLockReason,
      this.draft,
      this.pullRequest,
      this.body,
      this.performedViaGithubApp,
      this.score});

  Items.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    repositoryUrl = json['repository_url'];
    labelsUrl = json['labels_url'];
    commentsUrl = json['comments_url'];
    eventsUrl = json['events_url'];
    htmlUrl = json['html_url'];
    id = json['id'];
    nodeId = json['node_id'];
    number = json['number'];
    title = json['title'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['labels'] != null) {
      labels = new List<Null>();
      json['labels'].forEach((v) {});
    }
    state = json['state'];
    locked = json['locked'];
    assignee = json['assignee'];
    if (json['assignees'] != null) {
      assignees = new List<Null>();
      json['assignees'].forEach((v) {});
    }
    milestone = json['milestone'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    closedAt = json['closed_at'];
    authorAssociation = json['author_association'];
    activeLockReason = json['active_lock_reason'];
    draft = json['draft'];
    pullRequest = json['pull_request'] != null
        ? new PullRequest.fromJson(json['pull_request'])
        : null;
    body = json['body'];
    performedViaGithubApp = json['performed_via_github_app'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['repository_url'] = this.repositoryUrl;
    data['labels_url'] = this.labelsUrl;
    data['comments_url'] = this.commentsUrl;
    data['events_url'] = this.eventsUrl;
    data['html_url'] = this.htmlUrl;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['number'] = this.number;
    data['title'] = this.title;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.labels != null) {
      data['labels'] = this.labels.map((v) => labels ?? '');
    }
    data['state'] = this.state;
    data['locked'] = this.locked;
    data['assignee'] = this.assignee;
    if (this.assignees != null) {
      data['assignees'] = this.assignees.map((v) => assignee ?? '');
    }
    data['milestone'] = this.milestone;
    data['comments'] = this.comments;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['closed_at'] = this.closedAt;
    data['author_association'] = this.authorAssociation;
    data['active_lock_reason'] = this.activeLockReason;
    data['draft'] = this.draft;
    if (this.pullRequest != null) {
      data['pull_request'] = this.pullRequest.toJson();
    }
    data['body'] = this.body;
    data['performed_via_github_app'] = this.performedViaGithubApp;
    data['score'] = this.score;
    return data;
  }
}

class User {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String type;
  bool siteAdmin;

  User(
      {this.login,
      this.id,
      this.nodeId,
      this.avatarUrl,
      this.gravatarId,
      this.url,
      this.htmlUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.organizationsUrl,
      this.reposUrl,
      this.eventsUrl,
      this.receivedEventsUrl,
      this.type,
      this.siteAdmin});

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    gravatarId = json['gravatar_id'];
    url = json['url'];
    htmlUrl = json['html_url'];
    followersUrl = json['followers_url'];
    followingUrl = json['following_url'];
    gistsUrl = json['gists_url'];
    starredUrl = json['starred_url'];
    subscriptionsUrl = json['subscriptions_url'];
    organizationsUrl = json['organizations_url'];
    reposUrl = json['repos_url'];
    eventsUrl = json['events_url'];
    receivedEventsUrl = json['received_events_url'];
    type = json['type'];
    siteAdmin = json['site_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['avatar_url'] = this.avatarUrl;
    data['gravatar_id'] = this.gravatarId;
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    data['followers_url'] = this.followersUrl;
    data['following_url'] = this.followingUrl;
    data['gists_url'] = this.gistsUrl;
    data['starred_url'] = this.starredUrl;
    data['subscriptions_url'] = this.subscriptionsUrl;
    data['organizations_url'] = this.organizationsUrl;
    data['repos_url'] = this.reposUrl;
    data['events_url'] = this.eventsUrl;
    data['received_events_url'] = this.receivedEventsUrl;
    data['type'] = this.type;
    data['site_admin'] = this.siteAdmin;
    return data;
  }
}

class PullRequest {
  String url;
  String htmlUrl;
  String diffUrl;
  String patchUrl;

  PullRequest({this.url, this.htmlUrl, this.diffUrl, this.patchUrl});

  PullRequest.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    htmlUrl = json['html_url'];
    diffUrl = json['diff_url'];
    patchUrl = json['patch_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    data['diff_url'] = this.diffUrl;
    data['patch_url'] = this.patchUrl;
    return data;
  }
}
