import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tinhte_api/feature_page.dart';
import 'package:tinhte_api/tag.dart';
import 'package:tinhte_api/thread.dart';
import 'package:tinhte_api/user.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api.dart';
import 'config.dart';
import 'screens/fp_view.dart';
import 'screens/member_view.dart';
import 'screens/tag_view.dart';
import 'screens/thread_view.dart';

void launchLink(State state, String link) async {
  if (link.startsWith(configSiteRoot)) {
    final parsed = await parseLink(state, link: link);
    if (parsed) return;

    final data = ApiData.of(state.context);
    if (data.hasToken) {
      link = "$configApiRoot?tools/login&oauth_token=${data.token.accessToken}&"
          "redirect_uri=${Uri.encodeQueryComponent(link)}";
    }
  }

  if (!await canLaunch(link)) return;

  launch(link);
}

void launchMemberView(State state, int userId) =>
    launchLink(state, "$configSiteRoot/members/$userId/");

Future<bool> parseLink(State state, {String link, String path}) {
  assert((link == null) != (path == null));
  var cancelled = false;
  final completer = Completer<bool>();
  var parsed = false;

  showDialog(
    context: state.context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
          content: Text('Just a moment...'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                cancelled = true;
                Navigator.of(context).pop();
              },
            )
          ],
        ),
  );

  final cancelDialog = () {
    if (cancelled) return;

    Navigator.of(state.context, rootNavigator: true).pop();
    cancelled = true;
  };

  apiGet(
    state,
    path ?? 'tools/parse-link?link=${Uri.encodeQueryComponent(link)}',
    onSuccess: (json) {
      if (cancelled) return;

      Route route;
      if (json.containsKey('tag') && json.containsKey('tagged')) {
        route = _parseTag(json);
      } else if (json.containsKey('thread') && json.containsKey('posts')) {
        route = _parseThread(json);
      } else if (json.containsKey('user')) {
        route = _parseUser(json);
      }

      if (route != null) {
        parsed = true;
        cancelDialog();
        Navigator.of(state.context).push(route);
      }
    },
    onError: (error) {
      debugPrint("$error");
    },
    onComplete: () {
      cancelDialog();
      completer.complete(parsed);
    },
  );

  return completer.future;
}

Route _parseTag(Map json) {
  final Map jsonTag = json['tag'];
  final tag = Tag.fromJson(jsonTag);
  if (tag.tagId == null) return null;

  if (json.containsKey('feature_page')) {
    final fp = FeaturePage.fromJson(json['feature_page']);
    if (fp.id != null) {
      return MaterialPageRoute(builder: (_) => FpViewScreen(fp));
    }
  }

  return MaterialPageRoute(
    builder: (_) => TagViewScreen(tag, initialJson: json),
  );
}

Route _parseThread(Map json) {
  final Map jsonThread = json['thread'];
  final thread = Thread.fromJson(jsonThread);
  if (thread.threadId == null) return null;

  return MaterialPageRoute(
    builder: (_) => ThreadViewScreen(thread, initialJson: json),
  );
}

Route _parseUser(Map json) {
  final Map jsonUser = json['user'];
  final user = User.fromJson(jsonUser);
  if (user.userId == null) return null;

  return MaterialPageRoute(
    builder: (_) => MemberViewScreen(user),
  );
}
