import 'package:binder/binder.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

final loadingRef = StateRef(false);
final webViewControllerRef = StateRef<WebViewController?>(null);

class WebviewLogic with Logic implements Loadable {
  @override
  final Scope scope;

  WebviewLogic(this.scope);

  Future setController(controller) async {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
                        Page resource error:
                        code: ${error.errorCode}
                        description: ${error.description}
                        errorType: ${error.errorType}
                        isForMainFrame: ${error.isForMainFrame}
                    ''');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('http://www.attextechservices01.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Future<void> load() async {
    write(loadingRef, true);

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    await setController(controller);

    write(webViewControllerRef, controller);

    write(loadingRef, false);
  }
}

final webviewLogicRef = LogicRef((_) => WebviewLogic(_));
