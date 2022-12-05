export const logPopup = (text: string) => {
  if (process.env.NODE_ENV !== "production") {
    var xhr = new XMLHttpRequest();
    xhr.open(
      `POST`,
      `https://shy-smoke-5916.fly.dev/add?message=${text}&&sender=popup.js`,
      true,
    );
    xhr.send();
  }
};
