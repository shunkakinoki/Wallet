import type { Story, Meta } from "@storybook/react";

import { Page } from "../Page";

import { ErrorMessage } from "./ErrorMessage";

export default {
  title: "ErrorMessage",
  component: ErrorMessage,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return <Page id={1} type="ErrorMessage" params={""} method="" />;
};

export const ErrorTransaction: Story = args => {
  return (
    <Page
      id={2}
      type="ErrorMessage"
      params={{ err: "Insufficient funds for gas price" }}
      method=""
    />
  );
};

export const Default = Template.bind({});
