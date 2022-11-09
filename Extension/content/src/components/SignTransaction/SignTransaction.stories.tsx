import type { Story, Meta } from "@storybook/react";
import React from "react";

import { Page } from "../Page";

import { SignTransaction } from "./SignTransaction";

export default {
  title: "SignTransaction",
  component: SignTransaction,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return <Page id={1} type="SignTransaction" params={""} method="" />;
};

export const UniswapGoerliWrap: Story = args => {
  return (
    <Page
      id={2}
      type="SignTransaction"
      params={{
        from: "0xd77d7a55d10a9d26ee838453973d40a287322587",
        to: "0xb4fbf271143f4fbf7b91a5ded31805e42b2208d6",
        data: "0xd0e30db0",
        value: "0x2386f26fc10000",
      }}
      method=""
    />
  );
};

export const Default = Template.bind({});
