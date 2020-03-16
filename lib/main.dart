import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
    home: WebViewExample(),
    debugShowCheckedModeBanner: false,
    title: "Webview Draft ",
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
    )));

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  WebViewController _controller;

  int url = 0;
  final _pageOptions = [
    "https://www.google.com/",
    "https://www.youtube.com/",
    "https://www.linkedin.com/",
    "https://twitter.com/home",
    "https://www.instagram.com/",
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          _controller.goBack();
          return canGoBack;
        } else {
          return !canGoBack;
        }
      },
      child: Scaffold(
        body: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (BuildContext ctxt,
                AsyncSnapshot<ConnectivityResult> snapShot) {
              if (!snapShot.hasData) return CircularProgressIndicator();
              var result = snapShot.data;
              switch (result) {
                case ConnectivityResult.none:
                  return Center(child: Text("No Internet Connection!"));
                case ConnectivityResult.mobile:
                case ConnectivityResult.wifi:
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 23.0),
                      child: WebView(
                        initialUrl: _pageOptions[url],
                        javascriptMode: JavascriptMode.unrestricted,
                        javascriptChannels: <JavascriptChannel>[
                          _toasterJavascriptChannel(context),
                        ].toSet(),
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          _controller = webViewController;
                        },
                      ),
                    ),
                  );
                default:
                  return Center(child: Text("No Internet Connection!"));
              }
            }),
          
        /* BOTTOM NAVİGATİON BAR TO GO TO URL WHICH IS INCLUDE ARRAY */ 

          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.black12),
            child: BottomNavigationBar(
              onTap: (int index) {
                print(index);
                setState(() {
                  url = index;
                  _controller.loadUrl(_pageOptions[url]);
                });
              },
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.orange,
              currentIndex: url,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    'NAV1',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.poll),
                  backgroundColor: Colors.red,
                  title: Text(
                    'NAV2',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.perm_identity),
                  title: Text(
                    'NAV3',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.personal_video),
                  title: Text(
                    'NAV4',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.enhanced_encryption),
                  title: Text(
                    'NAV5',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

// Configure to JAVA SCRİPT formats.
JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });
}
