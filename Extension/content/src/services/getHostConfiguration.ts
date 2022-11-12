export const getHostConfiguration = () => {
  const request = {
    subject: "getHostConfiguration",
    host: window.location.host,
  };
  return browser.runtime
    .sendMessage("io.magic.light.Light-Safari-Extension (4Z47XRX22C)", request)
    .then(response => {
      return response;
    });
};
