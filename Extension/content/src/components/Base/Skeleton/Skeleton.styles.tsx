import { keyframes } from "@emotion/react";
import styled from "@emotion/styled";

type SkeletonProps = {
  width?: string;
  height?: string;
  marginTop?: string;
};

const skeletonKeyframes = keyframes`
  0% {
    background-position: -200px 0;
  }
  100% {
    background-position: calc(200px + 100%) 0;
  }
`;

export const Skeleton = styled.div`
  display: inline-block;
  height: ${(props: SkeletonProps) => {
    return props.height || "14px";
  }};
  width: ${(props: SkeletonProps) => {
    return props.width || "80%";
  }};
  animation: ${skeletonKeyframes} 1300ms ease-in-out infinite;
  background-color: #afadad;
  background-image: linear-gradient(90deg, #afadad, #cccccc, #afadad);
  background-size: 200px 100%;
  background-repeat: no-repeat;
  border-radius: 4px;
  margin-top: ${(props: SkeletonProps) => {
    return props.marginTop || "0";
  }};
`;
