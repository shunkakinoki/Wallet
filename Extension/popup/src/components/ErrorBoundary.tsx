import type { ErrorInfo, ReactNode } from "react";
import { Component } from "react";

import { logPopup } from "../utils/log";

interface Props {
  children?: ReactNode;
}

interface State {
  hasError: boolean;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
  };

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  public static getDerivedStateFromError(_: Error): State {
    // Update state so the next render will show the fallback UI.
    return { hasError: true };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error("Uncaught error:", error, errorInfo);
    logPopup(`popupError: ${error.message}`);
    // eslint-disable-next-line no-undef
    if (process.env.NODE_ENV === "production") {
      fetch("https://wallet.light.so/api/report", {
        method: "POST",
        body: JSON.stringify({
          host: "popup",
          error: error.message,
        }),
        headers: new Headers({
          "Content-Type": "application/json",
          Accept: "application/json",
        }),
      });
    }
  }

  public render() {
    if (this.state.hasError) {
      return <h1>Sorry.. there was an error</h1>;
    }

    return this.props.children;
  }
}
