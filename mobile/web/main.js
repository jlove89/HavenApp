const SERVER_URL = 'https://havenapp-api-yourname.herokuapp.com/api';

window.flutterConfiguration = {
  serviceWorkerVersion: null,
  onEntrypointLoaded: async function(engineInitializer) {
    let appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
  }
};
