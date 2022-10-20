# iOS-NewsApp

In this Application i used a free API that returns a limited Headlines with all necessary details like: title, description, URL to source article and...

In the home page will appear the last 20 Top Headlines and it's possible to navigate to the article's url to see the complete details, i used Safari's webView to open article's url.

**NewsAppLoadingProtocol**

I used a protocol to manage Loading Indicator in viewController: (whenever we want to show the Loading indicator, just need to conform the "ViewController" to protocol "NewsAppLoadingProtocol" and then call functions "showLoadingIndicator", "closeLoadingIndicator"):

![Protocol to manage loading Indicator](https://user-images.githubusercontent.com/40691961/197011415-e3e775d3-b365-40fd-bff4-a5b77e4eddfe.png)

**APICaller**

I created the singleton "APICaller" just to perform API Calls.

**MVVM Architecture**

I used mvvm architecture to separate all responsibilities between different layers:
ViewModels, Views, APICaller, Models, protocols

**AppIcone**

![App Icone](https://user-images.githubusercontent.com/40691961/197013773-fbb3610b-2a09-47e2-91de-932c04bdbda1.png)

**Home Page after run the application with Loading Indicator**

![Home Loading Indicator using Protocol](https://user-images.githubusercontent.com/40691961/197014111-17fcc8ce-135e-4a56-8aa2-9fe12e618d16.png)

**Home page after hide loading indicator**

![Home](https://user-images.githubusercontent.com/40691961/197014383-535e9e02-aaa3-4ba5-9f2c-cea3d035a731.png)

**Type a word to make a news search and pull the last 100 related articles**

![Search](https://user-images.githubusercontent.com/40691961/197014829-7f8a6ab7-d21d-44e9-a6f5-b64190e79253.png)

**Navigate to article's complete details after click any article**

![SafariWebView](https://user-images.githubusercontent.com/40691961/197015009-b1af0e22-44ec-4809-a9c2-095c946be9d3.png)

**Pull To Refresh Home screen with Empty Search Bar**

![Pull to refresh - Home](https://user-images.githubusercontent.com/40691961/197015651-45bd4f67-0e23-4737-940e-35bcdc7fe0ff.png)

**Pull To Refresh Home screen with Non Empty Search Bar**

![Pull to refresh - serach bar](https://user-images.githubusercontent.com/40691961/197015847-70cef20c-499e-490f-9944-04d43c77aaf1.png)

