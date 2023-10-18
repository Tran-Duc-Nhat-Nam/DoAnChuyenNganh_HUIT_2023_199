import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ManHinhXemWeb extends StatefulWidget {
  const ManHinhXemWeb({
    super.key,
    required this.controller,
    required this.url,
  });

  final WebViewController controller;
  final String url;

  @override
  _ManHinhXemWebState createState() => _ManHinhXemWebState();
}

class _ManHinhXemWebState extends State<ManHinhXemWeb> {
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await widget.controller.canGoBack()) {
                    await widget.controller.goBack();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('No back history item')),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await widget.controller.canGoForward()) {
                    await widget.controller.goForward();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('No forward history item')),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  widget.controller.reload();
                },
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: widget.controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
