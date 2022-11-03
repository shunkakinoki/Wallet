export const storeLightConfiguration = payload => {
  const request = {
    subject: "storeLightConfiguration",
    payload: payload,
  };
  browser.runtime.sendMessage(request).then(response => {
    return response;
  });
};
