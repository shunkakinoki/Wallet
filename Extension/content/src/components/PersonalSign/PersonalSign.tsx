import type { FC } from "react";

import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { hexToUtf8 } from "../../utils/hexToUtf8";
import { ConfirmButton } from "../Base/ConfirmButton";

import { PersonalSignDescriptionContainer } from "./PersonalSign.styles";

type PersonalSignParams = {
  id: number;
  method: string;
  params: any;
};

export const PersonalSign: FC<PersonalSignParams> = ({
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

export const PersonalSignDescription: FC<
  Pick<PersonalSignParams, "params">
> = ({ params }) => {
  if (params?.message) {
    return (
      <PersonalSignDescriptionContainer>
        {hexToUtf8(params.message)}
      </PersonalSignDescriptionContainer>
    );
  }

  return null;
};
