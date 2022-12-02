export const blowfishSupportedCheck = () => {
  const blowfishSupportedChainIds = ["0x1", "0x5", "0x89"];
  return blowfishSupportedChainIds.includes(window.ethereum.chainId);
};
