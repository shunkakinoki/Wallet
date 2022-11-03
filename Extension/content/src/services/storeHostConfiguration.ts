export const storeHostConfiguration = payload => {
  const request = {
    subject: "storeHostConfiguration",
    host: window.location.host,
    payload: payload,
  };
  browser.runtime.sendMessage(request).then(response => {
    return response;
  });
};
