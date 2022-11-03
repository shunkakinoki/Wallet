export const getTitle = () => {
  if (document.title) {
    return document.title.split(/-(.*)/s)[0] ?? "";
  }

  return "";
};
