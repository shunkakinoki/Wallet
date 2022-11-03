export const allowedDomainCheck = () => {
  const allowedDomains = [
    "alpha.ens.domains",
    "app.uniswap.org",
    "guild.xyz",
    "opensea.io",
    "sound.xyz",
    "showtime.xyz",
  ];
  const currentUrl = window.location.href;
  let currentRegex;
  for (let i = 0; i < allowedDomains.length; i++) {
    const allowedDomain = allowedDomains[i].replace(".", "\\.");
    currentRegex = new RegExp(
      `(?:https?:\\/\\/)(?:(?!${allowedDomain}).)*$`,
      "u",
    );
    if (!currentRegex.test(currentUrl)) {
      return true;
    }
  }
  return false;
};
