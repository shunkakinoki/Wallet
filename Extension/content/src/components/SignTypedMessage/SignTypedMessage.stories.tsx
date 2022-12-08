import type { Story, Meta } from "@storybook/react";

import { Page } from "../Page";

import { SignTypedMessage } from "./SignTypedMessage";

export default {
  title: "SignTypedMessage",
  component: SignTypedMessage,
  argTypes: {},
} as Meta;

const Template: Story = args => {
  return <Page id={1} type="SignTypedMessage" params={""} method="" />;
};

export const OpenseaTestnet: Story = args => {
  return (
    <Page
      id={2}
      type="SignTypedMessage"
      params={{
        from: "0xd77d7a55d10a9d26ee838453973d40a287322587",
        message:
          "0xe3ed813cc0ddec56469867e18aa63bdc1153a859244fe1e95b2a14e7b1835e29",
        raw: '{"types":{"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}],"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}]},"primaryType":"OrderComponents","domain":{"name":"Seaport","version":"1.1","chainId":"5","verifyingContract":"0x00000000006c3852cbEf3e08E8dF289169EdE581"},"message":{"offerer":"0xD77D7a55d10A9D26ee838453973D40a287322587","offer":[{"itemType":"1","token":"0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6","identifierOrCriteria":"0","startAmount":"30000000000000000","endAmount":"30000000000000000"}],"consideration":[{"itemType":"2","token":"0x444765c57A9aB702Cb09AB30BD556791A2d468F5","identifierOrCriteria":"8","startAmount":"1","endAmount":"1","recipient":"0xD77D7a55d10A9D26ee838453973D40a287322587"},{"itemType":"1","token":"0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6","identifierOrCriteria":"0","startAmount":"750000000000000","endAmount":"750000000000000","recipient":"0x0000a26b00c1F0DF003000390027140000fAa719"}],"startTime":"1666671960","endTime":"1666931155","orderType":"0","zone":"0x0000000000000000000000000000000000000000","zoneHash":"0x0000000000000000000000000000000000000000000000000000000000000000","salt":"24446860302761739304752683030156737591518664810215442929801702602056110723575","conduitKey":"0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000","totalOriginalConsiderationItems":"2","counter":"0"}}',
      }}
      method="eth_signTypedData_v4"
    />
  );
};

export const Default = Template.bind({});
