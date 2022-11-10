import { EventEmitter } from "events";

export class BaseProvider extends EventEmitter {
  providerNetwork: any;
  callbacks: any;
  isLight: boolean;
  logger: (text: any) => void;

  constructor(logger) {
    super();
    this.logger = logger;
    this.isLight = true;
  }

  /**
   * @private Internal js -> native message handler
   */
  postMessage(handler, id, data) {
    let object = {
      id: id,
      name: handler,
      object: data,
      network: this.providerNetwork,
    };
    if (window.lightwallet.postMessage) {
      window.lightwallet.postMessage(object);
    } else {
      console.error("postMessage is not available");
    }
  }

  /**
   * @private Internal native result -> js
   */
  sendResponse(id, result) {
    let callback = this.callbacks.get(id);
    this.logger(
      `<== sendResponse id: ${id}, result: ${JSON.stringify(result)}`,
    );
    if (callback) {
      callback(null, result);
      this.callbacks.delete(id);
    } else {
      this.logger(`callback id: ${id} not found`);
    }
  }

  /**
   * @private Internal native error -> js
   */
  sendError(id, error) {
    this.logger(`<== ${id} sendError ${error}`);
    let callback = this.callbacks.get(id);
    if (callback) {
      callback(error instanceof Error ? error : new Error(error), null);
      this.callbacks.delete(id);
    }
  }
}
