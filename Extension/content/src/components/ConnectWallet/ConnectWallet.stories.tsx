import type { Story, Meta } from "@storybook/react";

import { Page } from "../Page";

import { ConnectWallet } from "./ConnectWallet";

export default {
  title: "ConnectWallet",
  component: ConnectWallet,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return <Page id={1} type="ConnectWallet" params={""} method="" />;
};

export const Phishing: Story = args => {
  return (
    <Page id={2} type="ConnectWallet" params={{ isPhishing: true }} method="" />
  );
};

export const Default = Template.bind({});
