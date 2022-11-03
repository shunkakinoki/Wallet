export const shortenName = (name: string) => {
  return name.match(/\b\w/g)?.join("").toUpperCase().substring(0, 3);
};
