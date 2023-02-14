import 'package:binder/binder.dart';
import 'package:flutter/material.dart';
import 'package:ramos_webview/state_manager/webview_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KWebviewWidget extends StatelessWidget {
  const KWebviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController? controller = context.watch(webViewControllerRef);
    return Scaffold(
      body: SafeArea(
        child: LogicLoader(
          refs: [webviewLogicRef],
          child: const Center(child: Text('Chargement')),
          builder: (context, loading, child) {
            if (!loading) {
              return WebViewWidget(controller: controller!);
            }
      
            return const Center(child: Text('Chargement1'));
          },
        ),
      ),
    );
  }
}
