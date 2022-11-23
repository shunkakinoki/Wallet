export const logContent = text => {
  console.log(text);
  var xhr = new XMLHttpRequest();
  xhr.open(
    `POST`,
    `https://falling-pond-4675.fly.dev/add?message=${text}&&sender=content.js`,
    true,
  );
  xhr.send();
};
