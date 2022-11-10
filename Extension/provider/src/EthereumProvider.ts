/* eslint-disable no-case-declarations */

import { TypedDataUtils, SignTypedDataVersion } from "@metamask/eth-sig-util";
import isUtf8 from "isutf8";

import { BaseProvider } from "./base_provider";
import { ProviderRpcError } from "./error";
import { IdMapping } from "./id_mapping";
import { RPCServer } from "./rpc";
import { rpcMapping } from "./rpc_mapping";
import { Utils } from "./utils";

export class EthereumProvider extends BaseProvider {
  idMapping: IdMapping;
  wrapResults: Map<any, any>;
  chainId: any;
  address: string;
  ready: boolean;
  networkVersion: string;
  rpc: RPCServer;
  didEmitConnectAfterSubscription: boolean;
  isMetaMask: boolean;
  logger: (text: any) => void;

  constructor(config, logger) {
    super(logger);
    this.setConfig(config);

    this.providerNetwork = "ethereum";
    this.idMapping = new IdMapping();
    this.callbacks = new Map();
    this.wrapResults = new Map();
    this.isMetaMask = true;
    this.isLight = true;
    this.logger = logger;

    this.emitConnect(this.chainId);

    this.didEmitConnectAfterSubscription = false;

    const originalOn = this.on;
    this.on = (...args) => {
      this.logger(`on: ${JSON.stringify(args)}`);
      if (args[0] == "connect") {
        setTimeout(() => {
          if (!window.ethereum.didEmitConnectAfterSubscription) {
            window.ethereum.emitConnect(window.ethereum.chainId);
            window.ethereum.didEmitConnectAfterSubscription = true;
          }
        }, 1);
      }
      return originalOn.apply(this, args);
    };

    setTimeout(() => {
      window.ethereum.emit("_initialized");
    }, 1);
  }

  externalDisconnect() {
    this.setAddress("");
    this.emit("disconnect");
    this.emit("accountsChanged", []);
  }

  setAddress(address) {
    this.logger(`setAddress: ${address}`);

    const lowerAddress = (address || "").toLowerCase();
    this.address = lowerAddress;
    this.ready = !!address;

    this.logger(`setAddress: ${this.address}`);
    this.logger(`setAddress: ${this.ready}`);

    try {
      for (var i = 0; i < window.frames.length; i++) {
        const frame = window.frames[i];
        if (frame.ethereum?.isLight) {
          frame.ethereum.address = lowerAddress;
          frame.ethereum.ready = !!address;
        }
      }
    } catch (error) {
      this.logger(error);
    }
  }

  setConfig(config) {
    this.setAddress(config.address);

    this.networkVersion = "" + config.chainId;
    this.chainId = "0x" + (config.chainId || 1).toString(16);
    this.rpc = new RPCServer(config.rpcUrl);
  }

  request(payload) {
    // this points to window in methods like web3.eth.getAccounts()
    var that = this;
    if (!(this instanceof EthereumProvider)) {
      that = window.ethereum;
    }
    return that._request(payload, false);
  }

  /**
   * @deprecated Listen to "connect" event instead.
   */
  isConnected() {
    return true;
  }

  isUnlocked() {
    return Promise.resolve(true);
  }

  /**
   * @deprecated Use request({method: "eth_requestAccounts"}) instead.
   */
  enable() {
    this.logger(
      "enable() is deprecated, please use window.ethereum.request({method: 'eth_requestAccounts'}) instead.",
    );
    if (!this.address) {
      // avoid double accounts request in uniswap
      return this.request({
        method: "eth_requestAccounts",
        params: [],
      });
    } else {
      return this.request({ method: "eth_accounts", params: [] });
    }
  }

  /**
   * @deprecated Use request() method instead.
   */
  send(payload) {
    this.logger(`==> send payload ${JSON.stringify(payload)}`);
    let response = { jsonrpc: "2.0", id: payload.id, result: null };
    switch (payload.method) {
      case "eth_accounts":
        response.result = this.eth_accounts();
        break;
      case "eth_coinbase":
        response.result = this.eth_coinbase();
        break;
      case "net_version":
        response.result = this.net_version();
        break;
      case "eth_chainId":
        response.result = this.eth_chainId();
        break;
      default:
        throw new ProviderRpcError(
          4200,
          `Trust does not support calling ${payload.method} synchronously without a callback. Please provide a callback parameter to call ${payload.method} asynchronously.`,
        );
    }
    return response;
  }

  /**
   * @deprecated Use request() method instead.
   */
  sendAsync(payload, callback) {
    this.logger(
      "sendAsync(data, callback) is deprecated, please use window.ethereum.request(data) instead.",
    );
    // this points to window in methods like web3.eth.getAccounts()
    var that = this;
    if (!(this instanceof EthereumProvider)) {
      that = window.ethereum;
    }
    if (Array.isArray(payload)) {
      Promise.all(
        payload.map(_payload => {
          return that._request(_payload);
        }),
      )
        .then(data => {
          return callback(null, data);
        })
        .catch(error => {
          return callback(error, null);
        });
    } else {
      that
        ._request(payload)
        .then(data => {
          return callback(null, data);
        })
        .catch(error => {
          return callback(error, null);
        });
    }
  }

  /**
   * @private Internal rpc handler
   */
  _request(payload, wrapResult = true) {
    this.idMapping.tryIntifyId(payload);
    this.logger(`==> _request payload ${JSON.stringify(payload)}`);
    this.fillJsonRpcVersion(payload);
    return new Promise((resolve, reject) => {
      if (!payload.id) {
        payload.id = Utils.genId();
      }
      this.callbacks.set(payload.id, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      });
      this.wrapResults.set(payload.id, wrapResult);

      this.logger(
        `==> _request callbacks: ${JSON.stringify(
          Array.from(this.callbacks.keys()),
        )}`,
      );

      switch (payload.method) {
        case "eth_coinbase":
          return this.sendResponse(payload.id, this.eth_coinbase());
        case "net_version":
          return this.sendResponse(payload.id, this.net_version());
        case "eth_chainId":
          return this.sendResponse(payload.id, this.eth_chainId());
        case "eth_sign":
          return this.eth_sign(payload);
        case "personal_sign":
          return this.personal_sign(payload);
        case "personal_ecRecover":
          return this.personal_ecRecover(payload);
        case "eth_signTypedData_v3":
          return this.eth_signTypedData(payload, SignTypedDataVersion.V3);
        case "eth_signTypedData":
        case "eth_signTypedData_v4":
          return this.eth_signTypedData(payload, SignTypedDataVersion.V4);
        case "eth_sendTransaction":
          return this.eth_sendTransaction(payload);
        case "eth_accounts":
        case "eth_requestAccounts":
          if (!this.address) {
            return this.eth_requestAccounts(payload);
          } else {
            return this.sendResponse(payload.id, this.eth_accounts());
          }
        case "wallet_watchAsset":
          return this.wallet_watchAsset(payload);
        case "wallet_addEthereumChain":
          return this.wallet_addEthereumChain(payload);
        case "wallet_switchEthereumChain":
          return this.wallet_switchEthereumChain(payload);
        case "wallet_requestPermissions":
        case "wallet_getPermissions":
          const permissions = [{ parentCapability: "eth_accounts" }];
          return this.sendResponse(payload.id, permissions);
        case "eth_newFilter":
        case "eth_newBlockFilter":
        case "eth_newPendingTransactionFilter":
        case "eth_uninstallFilter":
        case "eth_subscribe":
          throw new ProviderRpcError(
            4200,
            `Trust does not support calling ${payload.method}. Please use your own solution`,
          );
        default:
          this.logger(`<== callback delete: ${payload.id}`);
          // call upstream rpc
          this.callbacks.delete(payload.id);
          this.wrapResults.delete(payload.id);
          return this.rpc
            .call(payload)
            .then(response => {
              this.logger(`<== rpc response ${JSON.stringify(response)}`);
              wrapResult ? resolve(response) : resolve(response.result);
            })
            .catch(reject);
      }
    });
  }

  fillJsonRpcVersion(payload) {
    if (payload.jsonrpc === undefined) {
      payload.jsonrpc = "2.0";
    }
  }

  emitConnect(chainId) {
    this.emit("connect", { chainId: chainId });
  }

  emitChainChanged(chainId) {
    this.emit("chainChanged", chainId);
    this.emit("networkChanged", chainId);
  }

  eth_accounts() {
    return this.address ? [this.address] : [];
  }

  eth_coinbase() {
    return this.address;
  }

  net_version() {
    return this.networkVersion;
  }

  eth_chainId() {
    return this.chainId;
  }

  eth_sign(payload) {
    const buffer = Utils.messageToBuffer(payload.params[1]);
    const hex = Utils.bufferToHex(buffer);
    if (isUtf8(buffer)) {
      this.postMessage("signPersonalMessage", payload.id, {
        from: this.address,
        message: hex,
      });
    } else {
      this.postMessage("signMessage", payload.id, {
        from: this.address,
        message: hex,
      });
    }
  }

  personal_sign(payload) {
    this.logger(`personal_sign: ${JSON.stringify(payload)}`);
    const message = payload.params[0];
    const from = payload.params[1];
    const buffer = Utils.messageToBuffer(message);
    if (buffer.length === 0) {
      this.logger("personal_sign: Buffer length is 0");
      // hex it
      const hex = Utils.bufferToHex(message);
      this.postMessage("signPersonalMessage", payload.id, {
        from: from,
        message: hex,
      });
    } else {
      this.logger("personal_sign: Buffer length is not 0");

      this.postMessage("signPersonalMessage", payload.id, {
        from: from,
        message: message,
      });
    }
  }

  personal_ecRecover(payload) {
    this.postMessage("ecRecover", payload.id, {
      signature: payload.params[1],
      message: payload.params[0],
    });
  }

  eth_signTypedData(payload, version) {
    this.logger(`signTypedMessage: ${JSON.stringify(payload)}`);

    const from = payload.params[0];
    const message = JSON.parse(payload.params[1]);
    const hash = TypedDataUtils.eip712Hash(message, version);

    this.postMessage("signTypedMessage", payload.id, {
      from: from,
      message: "0x" + hash.toString("hex"),
      raw: payload.params[1],
    });
  }

  eth_sendTransaction(payload) {
    this.postMessage("signTransaction", payload.id, payload.params[0]);
  }

  eth_requestAccounts(payload) {
    this.postMessage("requestAccounts", payload.id, {});
  }

  wallet_watchAsset(payload) {
    let options = payload.params.options;
    this.postMessage("watchAsset", payload.id, {
      type: payload.type,
      contract: options.address,
      symbol: options.symbol,
      decimals: options.decimals || 0,
    });
  }

  wallet_addEthereumChain(payload) {
    this.postMessage("addEthereumChain", payload.id, payload.params[0]);
  }

  wallet_switchEthereumChain(payload) {
    this.postMessage("switchEthereumChain", payload.id, payload.params[0]);
  }

  processLightWalletResponse(response, id, method) {
    this.logger(
      `<== processLightWalletResponse: ${JSON.stringify({
        id: id,
        response: response,
        method: method,
      })}`,
    );

    switch (method) {
      case "cancel":
        this.sendResponse(id, response);
        break;
      case "signTransaction":
        if (!response.startsWith("0x")) {
          this.sendError(id, "Transaction Failed");
        }
        window.ethereum
          .request({
            method: "eth_sendRawTransaction",
            params: [response],
          })
          .then(response => {
            this.sendResponse(id, response);
          })
          .catch(err => {
            this.logger(`signTransaction error: ${err}`);
            this.sendError(id, err);

            fetch("https://wallet.light.so/api/report", {
              method: "POST",
              body: JSON.stringify({
                host: window.location.host,
                error: err.message,
              }),
              headers: new Headers({
                "Content-Type": "application/json",
                Accept: "application/json",
              }),
            });
          });
        break;
      case "signPersonalMessage":
        if (!response.startsWith("0x")) {
          this.sendError(id, "Transaction Failed");
        }
        this.sendResponse(id, response);
        break;
      case "signTypedMessage":
        if (!response.startsWith("0x")) {
          this.sendError(id, "Transaction Failed");
        }
        this.sendResponse(id, response);
        break;
      case "changeAccount":
      case "requestAccounts":
        const addresses = (response as unknown as string)
          .replace("[", "")
          .replace("]", "")
          .replaceAll('"', "")
          .split(",");

        window.ethereum.emit("accountsChanged", addresses);
        this.setAddress(addresses[0]);
        this.sendResponse(id, addresses);
        break;
      case "changeChainId":
      case "switchEthereumChain":
        const chainId = response.chainId;
        this.chainId = chainId;
        this.networkVersion = parseInt(chainId, 16).toString();
        this.rpc = new RPCServer(rpcMapping[chainId]);
        window.ethereum.emit("chainChanged", chainId);
        window.ethereum.emit("networkChanged", window.ethereum.net_version());
        this.sendResponse(id, response);
        break;
    }
  }

  /**
   * @private Internal js -> native message handler
   */
  postMessage(method, id, params) {
    if (
      this.ready ||
      method === "requestAccounts" ||
      method === "switchEthereumChain" ||
      method === "addEthereumChain"
    ) {
      window.lightwallet.postMessage(method, id, params);
    } else {
      // don't forget to verify in the app
      this.sendError(id, new ProviderRpcError(4100, "provider is not ready"));
    }
  }

  /**
   * @private Internal native result -> js
   */
  sendResponse(id, result) {
    this.logger(
      `==> sendResponse callbacks: ${JSON.stringify(
        Array.from(this.callbacks.keys()),
      )}`,
    );

    let originId = this.idMapping.tryPopId(id) || id;
    let callback = this.callbacks.get(id);
    let wrapResult = this.wrapResults.get(id);
    let data = { jsonrpc: "2.0", id: originId, result: null };
    if (
      result !== null &&
      typeof result === "object" &&
      result.jsonrpc &&
      result.result
    ) {
      data.result = result.result;
    } else {
      data.result = result;
    }

    if (callback) {
      this.logger(
        `<== sendResponse: ${JSON.stringify({
          id: id,
          result: result,
          data: data,
        })}`,
      );

      this.logger(`<== callbackId wrapResult: ${JSON.stringify(wrapResult)}`);
      wrapResult ? callback(null, data) : callback(null, result);

      this.logger(`<== callback delete: ${id}`);
      this.callbacks.delete(id);
    } else {
      this.logger(`<== callbackId: ${id} not found`);
      // check if it's iframe callback
      for (var i = 0; i < window.frames.length; i++) {
        const frame = window.frames[i];
        try {
          if (frame.ethereum.callbacks.has(id)) {
            frame.ethereum.sendResponse(id, result);
          }
        } catch (error) {
          this.logger(`send response to frame error: ${error}`);
        }
      }
    }
  }

  /**
   * @private Internal native result -> js
   */
  sendError(id, error) {
    this.logger(`<== ${id} sendError: ${error}`);
    let callback = this.callbacks.get(id);
    if (callback) {
      callback(error instanceof Error ? error : new Error(error), null);
      this.callbacks.delete(id);
    }
  }
}
