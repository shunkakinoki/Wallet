import type { FC } from "react";

import ReactJson from "react-json-view";

import { useBlowfishMessage } from "../../hooks/useBlowfishMessage";

import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import { SignTypedMessageDescriptionContainer } from "./SignTypedMessage.styles";

type SignTypedMessageParams = {
  id: number;
  method: "";
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
        <ReactJson
          src={JSON.parse(params?.raw)?.message}
          style={{
            backgroundColor: "transparent",
          }}
          theme="grayscale:inverted"
          enableClipboard={false}
          displayObjectSize={false}
          displayDataTypes={true}
          quotesOnKeys={false}
          indentWidth={2}
          collapseStringsAfterLength={20}
        />
      </SignTypedMessageDescriptionContainer>
    );
  }

  return null;
};
