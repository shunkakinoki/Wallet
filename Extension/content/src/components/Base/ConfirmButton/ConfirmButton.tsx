import type { FC } from "react";

import { useShowDrawer } from "../../../hooks/useShowDrawer";
import { sendToEthereum } from "../../../services/sendToEthereum";

import { ConfirmButtonContainer, Button } from "./ConfirmButton.styles";

type ConfirmButtonParams = {
  id: number;
  disabled?: boolean;
  loading?: boolean;
  onCancelText?: string;
  onCancelClick?: () => void;
  onConfirmText: string;
  onConfirmClick: () => void;
};

export const ConfirmButton: FC<ConfirmButtonParams> = ({
  id,
  loading = false,
  disabled = false,
  onCancelText = "Cancel",
  onCancelClick,
  onConfirmText,
  onConfirmClick,
}) => {
  const [closeDrawer] = useShowDrawer(state => {
    return [state.closeDrawer];
  });

  if (disabled) {
    return (
      <ConfirmButtonContainer>
        <Button
          option="cancel"
          onClick={() => {
            sendToEthereum(null, id, "cancel");
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
        }}
      >
        {onConfirmText}
      </Button>
    </ConfirmButtonContainer>
  );
};
