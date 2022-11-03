export const getLightConfiguration = () => {
  const request = {
    subject: "getLightConfiguration",
  };
  return browser.runtime.sendMessage(request).then(response => {
    return response;
  });
};
