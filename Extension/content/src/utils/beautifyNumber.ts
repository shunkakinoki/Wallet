export const beautifyNumber = (num: number) => {
  return num.toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: num > 1e3 ? 2 : num > 1 ? 3 : 5,
  });
};
