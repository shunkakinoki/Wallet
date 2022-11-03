import { keyframes } from "@emotion/react";
import styled from "@emotion/styled";

export const DrawerBackground = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  left: 0;
  height: 100%;
  width: 100%;
  min-height: 100vh;
  min-height: -webkit-fill-available;
  z-index: 2147483646;
  background-color: rgba(0, 0, 0, 0.6);
  overflow: hidden;
  backdrop-filter: blur(12px);

  @media only screen and (min-width: 600px) {
    display: flex;
    justify-content: center;
  }
`;

type DrawerContentProps = {
  show: boolean;
};

const fadeIn = keyframes`
  from {
    transform: translate3d(0, 100%, 0);
  }
  to {
    transform: translate3d(0, 0%, 0);
  }
`;

const fadeOut = keyframes`
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
`;

export const DrawerContent = styled.div`
  z-index: 2147483647;
  position: absolute;
  width: 100%;
  bottom: 0;
  visibility: ${(props: DrawerContentProps) => {
    return props.show ? "visible" : "hidden";
  }};
  animation-name: ${(props: DrawerContentProps) => {
    return props.show ? fadeIn : fadeOut;
  }};
  animation-duration: 300ms;
  animation-timing-function: cubic-bezier(0.15, 1.15, 0.6, 1);

  @media only screen and (min-width: 600px) {
    max-width: 690px;
  }
`;
