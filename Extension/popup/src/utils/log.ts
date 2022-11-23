export const logPopup = (text: string) => {
  var xhr = new XMLHttpRequest();
  xhr.open(
    `POST`,
    `https://falling-pond-4675.fly.dev/add?message=${text}&&sender=popup.js`,
    true,
  );
  xhr.send();
};
