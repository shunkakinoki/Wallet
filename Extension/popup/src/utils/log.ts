export const logPopup = (text: string) => {
  var xhr = new XMLHttpRequest();
  xhr.open(
    `POST`,
    `https://icy-shadow-9979.fly.dev/add?message=${text}&&sender=popup.js`,
    true,
  );
  xhr.send();
};
