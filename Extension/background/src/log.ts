export const logBackground = text => {
  console.log(text);
  var xhr = new XMLHttpRequest();
  xhr.open(
    `POST`,
    `https://icy-shadow-9979.fly.dev/add?message=${text}&&sender=background.js`,
    true,
  );
  xhr.send();
};
