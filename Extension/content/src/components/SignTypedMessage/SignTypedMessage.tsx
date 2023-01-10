import type { FC } from "react";

import { useBlowfishMessage } from "../../hooks/useBlowfishMessage";

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
      method={method}
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
  const { result } = useBlowfishMessage(params);

  if (params.raw && params?.from) {
    return (
      <SignTypedMessageDescriptionContainer>
        <div>
          <pre>
            {params?.raw && JSON.parse(params?.raw)?.message
              ? JSON.stringify(JSON.parse(params?.raw)?.message, null, 1)
              : params?.raw}
          </pre>
        </div>
      </SignTypedMessageDescriptionContainer>
    );
  }

  return null;
};
