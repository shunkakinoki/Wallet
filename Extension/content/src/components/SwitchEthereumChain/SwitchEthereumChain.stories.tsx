import type { Story, Meta } from "@storybook/react";
import React from "react";

import { Page } from "../Page";

import { SwitchEthereumChain } from "./SwitchEthereumChain";

export default {
  title: "SwitchEthereumChain",
  component: SwitchEthereumChain,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return (
    <Page
      id={1}
      type="SwitchEthereumChain"
      params={{
        chainId: "0x89",
      }}
      method="eth_switchEthereumChain"
    />
  );
};

export const Default = Template.bind({});
