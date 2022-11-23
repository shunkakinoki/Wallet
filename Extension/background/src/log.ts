export const logBackground = text => {
  console.log(text);
  var xhr = new XMLHttpRequest();
  xhr.open(
    `POST`,
    `https://falling-pond-4675.fly.dev/add?message=${text}&&sender=background.js`,
    true,
  );
  xhr.send();
};
