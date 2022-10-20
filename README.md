# iOS-NewsApp

In this Application i used a free API that returns a limited Headlines with all necessary details like: title, description, URL to source news and ...
In the home page will appear the last 20 Top Headlines and it's possible to navigate to the article's url to see the complete details, i used Safari's webView to open article's url.

** I used a protocol to manage Loading Indicator in viewController: (whenever we want to show the Loading indicator, just need to conform the "ViewController" to protocol "NewsAppLoadingProtocol" and then call functions "showLoadingIndicator", "closeLoadingIndicator"):

![Protocol to manage loading Indicator](https://user-images.githubusercontent.com/40691961/197011415-e3e775d3-b365-40fd-bff4-a5b77e4eddfe.png)
