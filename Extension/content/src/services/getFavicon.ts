export const getFavicon = () => {
  if (document.favicon) {
    return document.favicon;
  }

  var nodeList = document.getElementsByTagName("link");
  for (var i = 0; i < nodeList.length; i++) {
    if (
      nodeList[i].getAttribute("rel") == "apple-touch-icon" ||
      nodeList[i].getAttribute("rel") == "icon" ||
      nodeList[i].getAttribute("rel") == "shortcut icon"
    ) {
      const favicon = nodeList[i].getAttribute("href");
      if (!favicon.endsWith("svg")) {
        document.favicon = favicon;
        return favicon;
      }
    }
  }
  return "";
};
