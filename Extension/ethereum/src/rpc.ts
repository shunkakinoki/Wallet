export class RPCServer {
  rpcUrl: any;

  constructor(rpcUrl) {
    this.rpcUrl = rpcUrl;
  }

  getBlockNumber() {
    return this.call({
      jsonrpc: "2.0",
      method: "eth_blockNumber",
      params: [],
    }).then(json => {
      return json.result;
    });
  }

  getBlockByNumber(number) {
    return this.call({
      jsonrpc: "2.0",
      method: "eth_getBlockByNumber",
      params: [number, false],
    }).then(json => {
      return json.result;
    });
  }

  getFilterLogs(filter) {
    return this.call({
      jsonrpc: "2.0",
      method: "eth_getLogs",
      params: [filter],
    });
  }

  call(payload) {
    return fetch(this.rpcUrl, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    })
      .then(response => {
        return response.json();
      })
      .then(json => {
        if (!json.result && json.error) {
          console.log("<== rpc error", json.error);
          throw new Error(json.error.message || "rpc error");
        }
        return json;
      });
  }
}
