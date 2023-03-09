# sandbox

The purpose of sandbox is to speed up the development process.

Sandobx can either show the App or individual widget you are working on at the moment.
When you change code and hot refresh the widget appears on the page so you don't have to look for it in the app to test it.

To toggle between app or widget use Cmd+Cmd on Mac (Ctrl+Ctrl on Windows?)


 ```SandboxLauncher(
    app: TheApp(),
    sandbox: Scaffold(
      body: TargetWidget()),
    getInitialState: () => kDB
        .doc('...')
        .get()
        .then((doc) => doc.data()!['sandbox']),
    saveState: (state) => {
      kDB.doc('...').set({'sandbox': state})
    },
  )
```

In this example Sandbox Launcher will either launch the app or the target widget based on the saved state in firestore.


Enjoy!
