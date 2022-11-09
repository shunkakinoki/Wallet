import { Utils } from "./utils";

export class IdMapping {
  intIds: Map<any, any>;

  constructor() {
    this.intIds = new Map();
  }

  tryIntifyId(payload) {
    if (!payload.id) {
      payload.id = Utils.genId();
      return;
    }
    if (typeof payload.id !== "number") {
      let newId = Utils.genId();
      this.intIds.set(newId, payload.id);
      payload.id = newId;
    }
  }

  tryRestoreId(payload) {
    let id = this.tryPopId(payload.id);
    if (id) {
      payload.id = id;
    }
  }

  tryPopId(id) {
    let originId = this.intIds.get(id);
    if (originId) {
      this.intIds.delete(id);
    }
    return originId;
  }
}
