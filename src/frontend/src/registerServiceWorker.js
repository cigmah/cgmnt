self.addEventListener('install', () => {
  self.skipWaiting();
  window.location.reload();

});

export function unregister() {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.ready.then(registration => {
      registration.unregister();
    });
  }
}
