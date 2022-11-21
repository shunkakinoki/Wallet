export const injectWagmi = (address: string) => {
  localStorage.setItem("rk-recent", '["injected"]');
  localStorage.setItem("wagmi.injected.shimDisconnect", "true");
  localStorage.setItem("wagmi.wallet", '"injected"');
  localStorage.setItem("wagmi.connected", "true");

  if (address) {
    localStorage.setItem(
      "wagmi.store",
      `"{\\"state\\":{\\"data\\":{\\"account\\":\\"${address}\\",\\"chain\\":{\\"id\\":1,\\"unsupported\\":false}},\\"chains\\":[{\\"id\\":1,\\"name\\":\\"Ethereum\\",\\"network\\":\\"homestead\\",\\"nativeCurrency\\":{\\"name\\":\\"Ether\\",\\"symbol\\":\\"ETH\\",\\"decimals\\":18},\\"rpcUrls\\":{\\"alchemy\\":\\"https://eth-mainnet.alchemyapi.io/v2\\",\\"default\\":\\"https://eth-mainnet.alchemyapi.io/v2/hqZ_E9STGs47Hu1ZFy3tGhToYC4b09T4\\",\\"infura\\":\\"https://mainnet.infura.io/v3\\",\\"public\\":\\"https://eth-mainnet.alchemyapi.io/v2/_gg7wSSi0KMBsdKnGVfHDueq6xMB9EkC\\"},\\"blockExplorers\\":{\\"etherscan\\":{\\"name\\":\\"Etherscan\\",\\"url\\":\\"https://etherscan.io\\"},\\"default\\":{\\"name\\":\\"Etherscan\\",\\"url\\":\\"https://etherscan.io\\"}},\\"ens\\":{\\"address\\":\\"0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e\\"},\\"multicall\\":{\\"address\\":\\"0xca11bde05977b3631167028862be2a173976ca11\\",\\"blockCreated\\":14353601}}]},\\"version\\":1}"`,
    );
  } else {
    localStorage.setItem(
      "wagmi.store",
      `"{\\"state\\":{\\"data\\":{},\\"chains\\":[{\\"id\\":1,\\"name\\":\\"Ethereum\\",\\"network\\":\\"homestead\\",\\"nativeCurrency\\":{\\"name\\":\\"Ether\\",\\"symbol\\":\\"ETH\\",\\"decimals\\":18},\\"rpcUrls\\":{\\"alchemy\\":\\"https://eth-mainnet.alchemyapi.io/v2\\",\\"default\\":\\"https://eth-mainnet.alchemyapi.io/v2/hqZ_E9STGs47Hu1ZFy3tGhToYC4b09T4\\",\\"infura\\":\\"https://mainnet.infura.io/v3\\",\\"public\\":\\"https://eth-mainnet.alchemyapi.io/v2/_gg7wSSi0KMBsdKnGVfHDueq6xMB9EkC\\"},\\"blockExplorers\\":{\\"etherscan\\":{\\"name\\":\\"Etherscan\\",\\"url\\":\\"https://etherscan.io\\"},\\"default\\":{\\"name\\":\\"Etherscan\\",\\"url\\":\\"https://etherscan.io\\"}},\\"ens\\":{\\"address\\":\\"0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e\\"},\\"multicall\\":{\\"address\\":\\"0xca11bde05977b3631167028862be2a173976ca11\\",\\"blockCreated\\":14353601}}]},\\"version\\":1}"`,
    );
  }
};
