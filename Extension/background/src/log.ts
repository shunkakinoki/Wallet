export const logBackground = text => {
  if (process.env.NODE_ENV !== "production") {
    console.log(text);
    var xhr = new XMLHttpRequest();
    xhr.open(
      `POST`,
      `https://icy-shadow-9979.fly.dev/add?message=${text}&&sender=background.js`,
      true,
    );
    xhr.send();
  }
};
