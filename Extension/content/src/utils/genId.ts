export const genId = () => {
  return new Date().getTime() + Math.floor(Math.random() * 1000);
};
