import type { FC } from "react";
import { useEffect } from "react";

import { useJitsu } from "../../../hooks/useJitsu";
import { useShowDrawer } from "../../../hooks/useShowDrawer";
import { sendToEthereum } from "../../../services/sendToEthereum";

import { ConfirmButtonContainer, Button } from "./ConfirmButton.styles";

type ConfirmButtonParams = {
  id: number;
  method: string;
  customConfirmData?: any;
  disabled?: boolean;
  loading?: boolean;
  value?: number;
  onCancelText?: string;
  onCancelClick?: () => void;
  onConfirmText: string;
  onConfirmClick: () => void;
};

export const ConfirmButton: FC<ConfirmButtonParams> = ({
  id,
  method,
  customConfirmData,
  loading = false,
  disabled = false,
  onCancelText = "Cancel",
  onCancelClick,
  onConfirmText,
  onConfirmClick,
}) => {
  const { track } = useJitsu();
  const [closeDrawer] = useShowDrawer(state => {
    return [state.closeDrawer];
  });

  useEffect(() => {
    track(method, { action: "open", chainId: window.ethereum.chainId });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (disabled) {
    return (
      <ConfirmButtonContainer>
        <Button
          option="cancel"
          onClick={() => {
            closeDrawer();
            sendToEthereum(null, id, "cancel");
            onCancelClick();
            track(method, {
              action: "cancelDisabled",
              chainId: window.ethereum.chainId,
            });
          }}
        >
          {onCancelText}
        </Button>
      </ConfirmButtonContainer>
    );
  }

  return (
    <ConfirmButtonContainer>
      <Button
        option="cancel"
        onClick={() => {
          closeDrawer();
          sendToEthereum(null, id, "cancel");
          onCancelClick();
          track(method, { action: "cancel", chainId: window.ethereum.chainId });
        }}
      >
        {onCancelText}
      </Button>
      <div style={{ width: "24px" }} />
      <Button
        option={loading ? "loading" : "approve"}
        onClick={() => {
          closeDrawer();
          onConfirmClick();
          track(method, {
            ...customConfirmData,
            action: "confirm",
            chainId: window.ethereum.chainId,
          });
        }}
      >
        {onConfirmText}
      </Button>
    </ConfirmButtonContainer>
  );
};
