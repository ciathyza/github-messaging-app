# github-messaging-app
An iOS example of a Github messaging app.

### Environment

Xcode 10, Swift 4.2

### Scenario

The app project has been structured so that it's easy for developers unfamiliar with it to find their way around the code. Classes have been written with good OOP practices in mind but as this can be seen as an initial prototype there is of course a lot of room for optimization. I wrote the code so that it is easily changeable and can easily be extended feature-wise. All is standard MVC.

### Specs

The mininum specifications have been fulfilled and there are a couple of additional changes:

- The start screen shows an input form where the 'since' parameter for the Github GET users API can be defined. I did this mainly for testing so by default it can be left at 0.
- Also on the start screen is a button to erase all persistent data.
- The user list thumbnails are round instead of rectangular.
- The chat messages are stored persistently using CoreData.
- UI look is up to par with latest iOS. (tested mostly on iPhone XS iOS 12 simulator).
- No external dependecies were used.

### Technical Notes

The `ChatViewController` and `ChatController` classes are doing the major bulk of the work. I decided to place all CoreData-related logic into `ChatController` because I don't want to have it in the view class. Therefore the `ChatController` class does all the management for sending and receiving chat messages and storing the messages.

The UI has mainly being laid out in the Main storyboard. Only the cells for the chat collection view are created via code.

