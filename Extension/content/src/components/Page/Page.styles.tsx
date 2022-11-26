import styled from "@emotion/styled";

export const PageContainer = styled.div`
  pointer-events: auto;
  background-color: white;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont,
    "Segoe UI", Roboto, "Helvetica Neue";
  font-size: 24px;
  border-top-left-radius: 14px;
  border-top-right-radius: 14px;
  border-width: 0px;
`;

export const PageHeaderContainer = styled.div`
  padding: 20px 18px 12px 16px;
  display: flex;
  align-items: center;

  font-size: 21px;
  font-weight: 650;
  color: #2b2929;
`;

export const PageHeaderLogoContainer = styled.div`
  flex: 1;
  display: flex;
  align-items: center;
  box-sizing: border-box;
`;

export const CloseButton = styled.button`
  cursor: pointer;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  margin: 0;
  background-color: #e0e0e0;
  transition: background-color 200ms ease, transform 150ms ease;
  border-width: 0px;
  border-radius: 9999px;

  &:hover {
    background: #c6c6c6;
  }
`;

export const PageBannerContainer = styled.div`
  padding: 10px 14px 12px 20px;
  font-size: 20px;
  font-weight: 300;
  color: #2b2929;
`;

export const PageBannerDataContainer = styled.div`
  padding: 10px 0px;
  font-size: 20px;
  font-weight: 300;
  color: #2b2929;
`;

export const LinkContainer = styled.div`
  display: flex;
  align-items: center;
  color: #838282;

  font-size: 18px;
  font-weight: 500;
  padding-top: 1.5px;
`;

export const LinkButton = styled.span`
  width: 18px;
  height: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  margin: 0;
  transition: background-color 200ms ease, transform 150ms ease;
  color: #838282;
`;

type PageDescriptionContainerProps = {
  error: boolean;
};

export const PageDescriptionContainer = styled.div<PageDescriptionContainerProps>`
  max-height: 45vh;
  overflow-wrap: break-word;
  overflow-x: scroll;
  overflow-y: scroll;

  display: flex;
  flex-direction: column;
  padding: 10px 14px 12px 20px;

  background-color: ${(props: PageDescriptionContainerProps) => {
    return props.error ? "#f8c5c5" : "#e0e0e0";
  }};
`;

export const PageDescriptionInfoContainer = styled.div`
  display: flex;
  align-items: center;
  font-size: 14px;
  font-weight: 500;
  color: #5f5b5b;
`;

export const PageTypeContainer = styled.div`
  padding: 16px 14px 16px 20px;
`;

export const InfoButton = styled.span`
  flex-shrink: 1;
`;
