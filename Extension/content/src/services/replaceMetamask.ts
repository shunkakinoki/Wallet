export const replace = (node, word, replacement) => {
  if (!node || !node?.nodeType) {
    return;
  }

  switch (node.nodeType) {
    case Node.ELEMENT_NODE:
      // We don't want to replace text in an input field or textarea.
      if (
        node.tagName.toLowerCase() === "input" ||
        node.tagName.toLowerCase() === "textarea"
      ) {
        return;
      }

    // For other types of element nodes, we explicitly fall through to iterate over their children.
    case Node.DOCUMENT_NODE:
    case Node.DOCUMENT_FRAGMENT_NODE:
      // If the node is a container node, iterate over all the children and recurse into them.
      var child = node.firstChild;
      var next = undefined;
      while (child) {
        next = child.nextSibling;
        replace(child, word, replacement);
        child = next;
      }
      break;
    case Node.TEXT_NODE:
      // If the node is a text node, perform the text replacement.
      replaceTextInTextNode(node, word, replacement);
      break;
  }
};

export const replaceMetamaskImages = node => {
  if (!node || !node?.nodeType) {
    return;
  }

  switch (node?.nodeType) {
    case Node.ELEMENT_NODE:
      // eslint-disable-next-line no-case-declarations
      const images = node.getElementsByTagName("img");
      for (const img of images) {
        const src = img.getAttribute("src");
        if (src.includes("metamask") || src.includes("tokenary")) {
          img.src = "https://wallet.light.so/logo.png";
        }
      }
      break;
  }
};

export const replaceTextInTextNode = (textNode, word, replacement) => {
  if (!textNode || !textNode?.nodeType) {
    return;
  }

  // Skip over nodes that aren't text nodes.
  if (textNode.nodeType !== Node.TEXT_NODE) return;

  // And text nodes that don't have any text.
  if (!textNode.nodeValue.length) return;

  // Generate a regular expression object to perform the replacement.
  var expressionForWordToReplace = new RegExp(word, "gi");
  var nodeValue = textNode.nodeValue;
  var newNodeValue = nodeValue.replace(expressionForWordToReplace, replacement);

  // Perform the replacement in the DOM if the regular expression had any effect.
  if (nodeValue !== newNodeValue) {
    textNode.nodeValue = newNodeValue;
  }
};

export const replaceMetamask = () => {
  replace(document.body, "MetaMask", "Light Wallet");
  replace(document.body, "Metamask", "Light Wallet");
  replace(document.body, "Injected", "Light");

  replace(
    document.querySelector("onboard-v2")?.shadowRoot?.querySelector("div"),
    "MetaMask",
    "Light Wallet",
  );

  replaceMetamaskImages(document.body);
  replaceMetamaskImages(
    document.querySelector("onboard-v2")?.shadowRoot?.querySelector("div"),
  );
};
