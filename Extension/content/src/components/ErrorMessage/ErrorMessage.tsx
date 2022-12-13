import type { FC } from "react";

import { useTransactionError } from "../../hooks/useTransactionError";
import { AlertIcon } from "../../icons/AlertIcon";

import { ConfirmButton } from "../Base/ConfirmButton";

import {
  ErrorMessageContainer,
  ErrorMessageErrorContainer,
} from "./ErrorMessage.styles";

type ErrorMessageParams = {
  id: number;
  method: string;
  params: any;
};

export const ErrorMessage: FC<ErrorMessageParams> = ({
  id,
  method,
  params,
}) => {
  const [error] = useTransactionError(state => {
    return [state.error];
  });

  return (
    <ConfirmButton
      id={id}
      method="ErrorMessage"
      disabled={error}
      onConfirmText="Report"
      onConfirmClick={() => {
        fetch("https://wallet.light.so/api/report", {
          method: "POST",
          body: JSON.stringify({
            host: window.location.host,
            error: params.err,
          }),
          headers: new Headers({
            "Content-Type": "application/json",
            Accept: "application/json",
          }),
        });
      }}
    />
  );
};

export const ErrorMessageDescription: FC<
  Pick<ErrorMessageParams, "params">
> = ({ params }) => {
  if (params?.err) {
    return (
      <ErrorMessageContainer
        style={{
          color: "#FF453A",
        }}
      >
        <ErrorMessageErrorContainer>
          <AlertIcon />
          <br />
          {params?.err}
        </ErrorMessageErrorContainer>
      </ErrorMessageContainer>
    );
  }

  return null;
};
