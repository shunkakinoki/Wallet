import type { Story, Meta } from "@storybook/react";

import { Page } from "../Page";

import { PersonalSign } from "./PersonalSign";

export default {
  title: "PersonalSign",
  component: PersonalSign,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return <Page id={1} type="PersonalSign" params={""} method="" />;
};

export const Lenster: Story = args => {
  return (
    <Page
      id={2}
      type="PersonalSign"
      params={{
        from: "0xd77d7a55d10a9d26ee838453973d40a287322587",
        message:
          "0x0a68747470733a2f2f6c656e737465722e78797a2077616e747320796f7520746f207369676e20696e207769746820796f757220457468657265756d206163636f756e743a0a3078443737443761353564313041394432366565383338343533393733443430613238373332323538370a0a5369676e20696e207769746820657468657265756d20746f206c656e730a0a5552493a2068747470733a2f2f6c656e737465722e78797a0a56657273696f6e3a20310a436861696e2049443a203133370a4e6f6e63653a20383931386235613763343337643161650a4973737565642041743a20323032322d31302d32355430343a30313a34332e3236395a0a20",
      }}
      method="personal_sign"
    />
  );
};

export const Default = Template.bind({});
