import type { Story, Meta } from "@storybook/react";
import React from "react";

import { Page } from "../Page";

import { ConnectWallet } from "./ConnectWallet";

export default {
  title: "ConnectWallet",
  component: ConnectWallet,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return <Page id={0} type="ConnectWallet" params={""} method="" />;
};

export const Default = Template.bind({});
