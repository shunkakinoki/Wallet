export const storeLightConfiguration = payload => {
  const request = {
    subject: "storeLightConfiguration",
    payload: payload,
  };
  browser.runtime
    .sendMessage("io.magic.light.Light-Safari-Extension (4Z47XRX22C)", request)
    .then(response => {
      return response;
    });
};
