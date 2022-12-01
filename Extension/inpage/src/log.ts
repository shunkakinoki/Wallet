export const logInpage = text => {
  if (process.env.NODE_ENV !== "production") {
    console.log(text);
    var xhr = new XMLHttpRequest();
    xhr.open(
      `POST`,
      `https://icy-shadow-9979.fly.dev/add?message=${text}&&sender=inpage.js`,
      true,
    );
    xhr.send();
  }
};
