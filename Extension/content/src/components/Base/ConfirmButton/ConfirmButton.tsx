import type { FC } from "react";
import { useEffect } from "react";

import { useJitsu } from "../../../hooks/useJitsu";
import { useShowDrawer } from "../../../hooks/useShowDrawer";
import { sendToEthereum } from "../../../services/sendToEthereum";

import { ConfirmButtonContainer, Button } from "./ConfirmButton.styles";

type ConfirmButtonParams = {
  id: number;
  method: string;
  disabled?: boolean;
  loading?: boolean;
  onCancelText?: string;
  onCancelClick?: () => void;
  onConfirmText: string;
  onConfirmClick: () => void;
};

export const ConfirmButton: FC<ConfirmButtonParams> = ({
  id,
  method,
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
    track(method, { action: "open" });
  });

  if (disabled) {
    return (
      <ConfirmButtonContainer>
        <Button
          option="cancel"
          onClick={() => {
            sendToEthereum(null, id, "cancel");
            track(method, { action: "cancelDisabled" });
            closeDrawer();
            onCancelClick();
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
          sendToEthereum(null, id, "cancel");
          track(method, { action: "cancel" });
          closeDrawer();
          onCancelClick();
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
          track(method, { action: "confirm" });
        }}
      >
        {onConfirmText}
      </Button>
    </ConfirmButtonContainer>
  );
};
