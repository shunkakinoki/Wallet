export const getHostConfiguration = () => {
  const request = {
    subject: "getHostConfiguration",
    host: window.location.host,
  };
  return browser.runtime.sendMessage(request).then(response => {
    return response;
  });
};
