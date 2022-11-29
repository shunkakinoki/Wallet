import type { FC } from "react";
import { useEffect } from "react";

import { useBlowfishMessage } from "../../hooks/useBlowfishMessage";
import { useTransactionError } from "../../hooks/useTransactionError";

import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import { SignTypedMessageDescriptionContainer } from "./SignTypedMessage.styles";

type SignTypedMessageParams = {
  id: number;
  method: string;
  params: any;
};

export const SignTypedMessage: FC<SignTypedMessageParams> = ({
  id,
  method,
  params,
}) => {
  return (
    <ConfirmButton
      id={id}
      onConfirmText="Sign"
      onConfirmClick={() => {
        sendMessageToNativeApp({ id, method, params });
      }}
    />
  );
};

export const SignTypedDescription: FC<
  Pick<SignTypedMessageParams, "params">
> = ({ params }) => {
  const [setError] = useTransactionError(state => {
    return [state.setError];
  });

  const { result } = useBlowfishMessage(params);

  useEffect(() => {
    if (typeof result?.warnings !== "undefined" && result?.warnings.length) {
      return setError(true);
    }
    setError(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [result?.warnings]);

  if (params.raw && params?.from) {
    return (
      <SignTypedMessageDescriptionContainer>
        {params?.raw && JSON.stringify(params?.raw)}
      </SignTypedMessageDescriptionContainer>
    );
  }

  return null;
};
