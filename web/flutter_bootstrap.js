{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load(
    {
        onEntrypointLoaded: async function(engineInitializer) {
            // Initialize the Flutter engine
            let appRunner = await engineInitializer.initializeEngine({useColorEmoji: true,});
            // Run the app
            // Remove the HTML splash only after Flutter has painted its first frame.
            window.addEventListener('flutter-first-frame', removeSplashFromWeb, {once: true});
            await appRunner.runApp();
          }
    }
);
