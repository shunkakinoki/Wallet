export const storeHostConfiguration = payload => {
  const request = {
    subject: "storeHostConfiguration",
    host: window.location.host,
    payload: payload,
  };
  browser.runtime
    .sendMessage("io.magic.light.Light-Safari-Extension (4Z47XRX22C)", request)
    .then(response => {
      return response;
    });
};
