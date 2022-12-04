export const testnetCheck = () => {
  return window.ethereum.chainId !== "0x5";
};
