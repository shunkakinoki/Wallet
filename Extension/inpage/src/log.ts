export const logInpage = text => {
  console.log(text);
  var xhr = new XMLHttpRequest();
  xhr.open(
    `POST`,
    `https://falling-pond-4675.fly.dev/add?message=${text}&&sender=inpage.js`,
    true,
  );
  xhr.send();
};
