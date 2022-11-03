export const hexToUtf8 = (s: string) => {
  return decodeURIComponent(
    s
      .replace(/\s+/g, "")
      .replace(/[0-9a-f]{2}/g, "%$&")
      .substring(2),
  );
};
