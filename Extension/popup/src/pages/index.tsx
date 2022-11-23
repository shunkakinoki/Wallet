/* eslint-disable @next/next/no-img-element */
/* eslint-disable jsx-a11y/alt-text */

import { GlobeAltIcon } from "@heroicons/react/24/outline";
import { ChainNames } from "@lightdotso/chain";
import {
  ListItem,
  List,
  Block,
  BlockHeader,
  Button,
  Dialog,
  DialogButton,
  ListInput,
} from "konsta/react";
import { useEffect, useState, useRef } from "react";

import { Avatar } from "../components/Avatar";
import { ChevronUpChevrondown } from "../icons/chevron.up.chevron.down";
import { EntryLeverKeypadTrianglebadgeExclamationmark } from "../icons/entry.lever.keypad.trianglebadge.exclamationmark";
import { ExclamationMarkBubble } from "../icons/exclamationmark.bubble";
import { Trash } from "../icons/trash";
import { logPopup } from "../utils/log";
import { shortenName } from "../utils/shortenName";
import { splitAddress } from "../utils/splitAddress";

export default function Home() {
  const [tabId, setTabId] = useState<null | number>(null);
  const [host, setHost] = useState<null | string>(null);
  const [accounts, setAccounts] = useState<null | any>(null);
  const [addresses, setAddresses] = useState<null | string[]>(null);

  const [reportOpened, setReportOpened] = useState(false);
  const [forgetOpened, setForgetOpened] = useState(false);
  const [historyOpened, setHistoryOpened] = useState(false);

  const [optionId, setOptionId] = useState<null | number>(null);
  const [selectOptionIdWidth, setSelectOptionIdWidth] = useState<null | number>(
    null,
  );
  const [shadowOptionIdOption, setShadowOptionIdOption] = useState<
    null | string
  >(null);

  const [accountId, setAccountId] = useState<null | string>(null);
  const [selectAccountIdWidth, setSelectAccountIdWidth] = useState<
    null | number
  >(null);
  const [shadowAccountIdOption, setShadowAccountIdOption] = useState<
    null | string
  >(null);

  const [chainId, setChainId] = useState<null | string>(null);
  const [selectChainIdWidth, setSelectChainIdWidth] = useState<null | number>(
    null,
  );
  const [shadowChainIdOption, setShadowChainIdOption] = useState<null | string>(
    null,
  );

  const optionIdRef = useRef<HTMLSelectElement | null>(null);
  const shadowOptionIdRef = useRef<HTMLSelectElement | null>(null);

  const accountIdRef = useRef<HTMLSelectElement | null>(null);
  const shadowAccountIdRef = useRef<HTMLSelectElement | null>(null);

  const chainIdRef = useRef<HTMLSelectElement | null>(null);
  const shadowChainIdRef = useRef<HTMLSelectElement | null>(null);

  const [issue, setIssue] = useState("");
  const [contact, setContact] = useState("email");
  const [handle, setHandle] = useState("");

  const [isFallback, setIsFallback] = useState(false);

  useEffect(() => {
    setIsFallback(false);
  }, [chainId]);

  useEffect(() => {
    setOptionId(-1);
    setShadowOptionIdOption("Default (Auto)");
  }, []);

  useEffect(() => {
    if (typeof browser !== "undefined" && typeof browser.tabs !== "undefined") {
      (browser.tabs as any).query(
        {
          active: true,
          currentWindow: true,
        },
        (tabs: browser.tabs.Tab[]) => {
          const [tab] = tabs;

          if (tab && tab.id) {
            setTabId(tab.id);

            let accountIdPayload = {
              direction: "from-popup-script",
              method: "get_windowAddress",
            };
            logPopup(
              `==> sendingMessageContent at ${tab.id}: ${JSON.stringify(
                accountIdPayload,
              )}`,
            );
            browser.tabs.sendMessage(tab.id, accountIdPayload).then(value => {
              logPopup(`<== sendingMessageContent: ${JSON.stringify(value)}`);

              setShadowAccountIdOption(value);
              setAccountId(value);
            });
            let accountsPayload = {
              direction: "from-popup-script",
              method: "get_windowAccounts",
            };
            logPopup(
              `==> sendingMessageContent at ${tab.id}: ${JSON.stringify(
                accountsPayload,
              )}`,
            );
            browser.tabs.sendMessage(tab.id, accountsPayload).then(value => {
              logPopup(`<== sendingMessageContent: ${JSON.stringify(value)}`);
              const obj = new Map(Object.entries(value));
              const addresses = Array.from(obj.keys()) as unknown as string[];
              setAccounts(value);
              setAddresses(addresses);
            });
            let hostPayload = {
              direction: "from-popup-script",
              method: "get_windowHost",
            };
            logPopup(
              `==> sendingMessageContent at ${tab.id}: ${JSON.stringify(
                hostPayload,
              )}`,
            );
            browser.tabs.sendMessage(tab.id, hostPayload).then(value => {
              logPopup(`<== sendingMessageContent: ${JSON.stringify(value)}`);
              setHost(value);
            });
            let chainIdPayload = {
              direction: "from-popup-script",
              method: "get_windowChainId",
            };
            logPopup(
              `==> sendingMessageContent at ${tab.id}: ${JSON.stringify(
                chainIdPayload,
              )}`,
            );
            browser.tabs.sendMessage(tab.id, chainIdPayload).then(value => {
              logPopup(`<== sendingMessageContent: ${JSON.stringify(value)}`);
              //@ts-expect-error
              setShadowChainIdOption(ChainNames[value]);
              setChainId(value);
            });
          }
        },
      );
    }
  }, []);

  useEffect(() => {
    if (shadowOptionIdRef?.current) {
      const width = shadowOptionIdRef?.current?.getBoundingClientRect().width;
      setSelectOptionIdWidth(width);
    }
  }, [shadowOptionIdOption]);

  useEffect(() => {
    if (shadowAccountIdRef?.current) {
      const width = shadowAccountIdRef?.current?.getBoundingClientRect().width;
      setSelectAccountIdWidth(width);
    }
  }, [shadowAccountIdOption]);

  useEffect(() => {
    if (shadowChainIdRef?.current) {
      const width = shadowChainIdRef?.current?.getBoundingClientRect().width;
      setSelectChainIdWidth(width);
    }
  }, [shadowChainIdOption]);

  return (
    <div className="flex justify-center min-w-[320px]">
      <div className="w-full max-w-lg">
        <BlockHeader className="ml-1.5 font-semibold">
          <div className="">
            {accountId ? (
              <div className="flex items-center fill-gray-300">
                <div className="pointer-events-none">
                  <Avatar
                    color={
                      accounts && addresses && accountId
                        ? accounts[accountId]?.icon ?? "pink"
                        : "pink"
                    }
                  />
                </div>
                <div className="ml-2">
                  <select
                    ref={accountIdRef}
                    // eslint-disable-next-line tailwindcss/no-custom-classname, tailwindcss/classnames-order
                    className="line-clamp-1 -mr-1.5 text-2xl whitespace-nowrap bg-inherit outline-none appearance-none"
                    style={{
                      width:
                        selectAccountIdWidth && shadowAccountIdOption
                          ? `${selectAccountIdWidth + 12}px`
                          : "58px",
                    }}
                    value={accountId}
                    onChange={e => {
                      if (typeof browser.tabs !== "undefined") {
                        (browser.tabs as any).query(
                          {
                            active: true,
                            currentWindow: true,
                          },
                          (tabs: browser.tabs.Tab[]) => {
                            let accountIdPayload = {
                              direction: "from-popup-script",
                              method: "write_windowAccount",
                              params: { wallet: e.target.value },
                            };
                            logPopup(
                              `==> sendingMessageContent at ${tabId}: ${JSON.stringify(
                                accountIdPayload,
                              )}`,
                            );
                            if (tabs && tabId) {
                              browser.tabs
                                .sendMessage(tabId, accountIdPayload)
                                .then(value => {
                                  logPopup(
                                    `<== sendingMessageContent: ${value}`,
                                  );

                                  // Set value
                                  setAccountId(e.target.value);
                                  setShadowAccountIdOption(e.target.value);
                                });
                            }
                          },
                        );
                      }
                      // Set value
                      setAccountId(e.target.value);
                      setShadowAccountIdOption(e.target.value);
                    }}
                  >
                    {accounts &&
                      addresses &&
                      addresses.map(address => {
                        return (
                          <>
                            <option key={address} value={address}>
                              {decodeURI(accounts[address].name).replace(
                                /%23/g,
                                "#",
                              )}
                            </option>
                          </>
                        );
                      })}
                  </select>
                  <div className="text-xs text-gray-400 dark:text-gray-500">
                    {splitAddress(accountId)}
                  </div>
                </div>
                <ChevronUpChevrondown />
              </div>
            ) : (
              <div className="text-base">Not logged in yet.</div>
            )}
          </div>
        </BlockHeader>
        <BlockHeader className="ml-4">
          <div className="flex items-center pt-4 text-base">
            <GlobeAltIcon className="mr-1.5 w-4 h-4" />
            {host}
          </div>
        </BlockHeader>
        <div className="pl-4 mt-12 -mb-7 ml-4 text-xs font-medium text-gray-600 dark:text-gray-300">
          ENABLED
        </div>
        <List strong inset className="mb-0 bg-gray-400">
          <ListItem
            title="Enabled"
            after={
              optionId && (
                <div className="flex items-center fill-gray-300">
                  <select
                    ref={optionIdRef}
                    className="-mr-4 text-base whitespace-nowrap bg-inherit outline-none appearance-none"
                    style={{
                      width:
                        selectOptionIdWidth && shadowChainIdOption
                          ? `${selectOptionIdWidth + 24}px`
                          : "82px",
                    }}
                    value={optionId}
                    onChange={e => {
                      if (typeof browser.tabs !== "undefined") {
                        (browser.tabs as any).query(
                          {
                            active: true,
                            currentWindow: true,
                          },
                          (tabs: browser.tabs.Tab[]) => {
                            let accountIdPayload = {
                              direction: "from-popup-script",
                              method: "write_windowAccount",
                              params: { option: e.target.value },
                            };
                            logPopup(
                              `==> sendingMessageContent at ${tabId}: ${JSON.stringify(
                                accountIdPayload,
                              )}`,
                            );
                            if (tabs && tabId) {
                              browser.tabs
                                .sendMessage(tabId, accountIdPayload)
                                .then(value => {
                                  logPopup(
                                    `<== sendingMessageContent: ${value}`,
                                  );

                                  const option =
                                    e.target.options[e.target.selectedIndex]
                                      .text;
                                  setShadowOptionIdOption(option);
                                  // Set value
                                  setOptionId(Number(e.target.value));
                                });
                            }
                          },
                        );
                      }

                      const option =
                        e.target.options[e.target.selectedIndex].text;
                      setShadowOptionIdOption(option);
                      // Set value
                      setOptionId(Number(e.target.value));
                    }}
                  >
                    <option value={-1}>Default (Auto)</option>
                    <option value={1}>Enabled</option>
                    <option value={5}>Disabled</option>
                  </select>
                  <ChevronUpChevrondown />
                </div>
              )
            }
            media={<div className="w-3 h-3 bg-green-400 rounded-full" />}
          />
        </List>
        <Block className="mt-2 mb-0 ml-4">
          <p className="text-xs font-medium text-gray-400">
            Light will connect wallet when Extension is enabled on this device.
          </p>
        </Block>
        <div className="pl-4 mt-12 -mb-7 ml-4 text-xs font-medium text-gray-600 dark:text-gray-300">
          WALLET SETTINGS
        </div>
        <List strong inset className="mb-0">
          <ListItem
            title="Chain"
            after={
              chainId && (
                <div className="flex items-center fill-gray-300">
                  <div>
                    {isFallback ? (
                      <span className="flex justify-center items-center w-5 h-5 text-xs font-semibold leading-none text-gray-400 bg-gray-200 rounded-full border dark:border-0 border-gray-400">
                        {/* @ts-expect-error */}
                        {shortenName(ChainNames[chainId] ?? "Undefined")}
                      </span>
                    ) : (
                      <img
                        //@ts-expect-error
                        src={`https://defillama.com/chain-icons/rsz_${ChainNames[chainId]}.jpg`}
                        className="w-5 h-5 rounded-full"
                        onError={() => {
                          return setIsFallback(true);
                        }}
                      />
                    )}
                  </div>
                  <select
                    ref={chainIdRef}
                    className="-mr-1 ml-2 text-base whitespace-nowrap bg-inherit outline-none appearance-none"
                    style={{
                      width:
                        selectChainIdWidth && shadowChainIdOption
                          ? `${selectChainIdWidth + 12}px`
                          : "82px",
                    }}
                    value={chainId}
                    onChange={e => {
                      if (typeof browser.tabs !== "undefined") {
                        (browser.tabs as any).query(
                          {
                            active: true,
                            currentWindow: true,
                          },
                          (tabs: browser.tabs.Tab[]) => {
                            let chainIdPayload = {
                              direction: "from-popup-script",
                              method: "write_windowChainId",
                              params: { chainId: e.target.value },
                            };
                            logPopup(
                              `==> sendingMessageContent at ${tabId}: ${JSON.stringify(
                                chainIdPayload,
                              )}`,
                            );
                            if (tabs && tabId) {
                              browser.tabs
                                .sendMessage(tabId, chainIdPayload)
                                .then(value => {
                                  logPopup(
                                    `<== sendingMessageContent: ${value}`,
                                  );

                                  // Set value
                                  setChainId(e.target.value);
                                });
                            }
                          },
                        );
                      }
                      // Set shadow option
                      const option =
                        e.target.options[e.target.selectedIndex].text;
                      setShadowChainIdOption(option);
                      // Set value
                      setChainId(e.target.value);
                    }}
                  >
                    <option value={"0x1"}>Ethereum</option>
                    <option value={"0x5"}>Goerli</option>
                    <option value={"0xa"}>Optimism</option>
                    <option value={"0x89"}>Polygon</option>
                    <option value={"0xa4b1"}>Arbitrum</option>
                  </select>
                  <ChevronUpChevrondown />
                </div>
              )
            }
            media={<div className="w-3 h-3 bg-blue-400 rounded-full" />}
          />
        </List>
        <Block className="mt-2 mb-0 ml-4">
          <p className="text-xs font-medium text-gray-400">
            Customize how the wallet will interact with the connected dapp.
          </p>
        </Block>
        <div className="pl-4 mt-12 -mb-7 ml-4 text-xs font-medium text-gray-600 dark:text-gray-300">
          ACTIONS
        </div>
        <List strong inset className="mb-0">
          <ListItem
            className="hover:bg-gray-300 dark:hover:bg-gray-800 cursor-pointer"
            title="Report Issue With This Website"
            mediaClassName="shrink-0 flex py-2 mr-2"
            media={
              <div className="flex justify-center items-center w-5 h-5 bg-red-600 rounded-md">
                <ExclamationMarkBubble />
              </div>
            }
            onClick={() => {
              return setReportOpened(true);
            }}
          />
          <Dialog
            opened={reportOpened}
            title="Light Wallet Issue Report"
            content={
              <>
                <div className="mt-2 mb-4 text-sm">
                  Report {host} not working?
                </div>
                <List className="my-4">
                  <ListInput
                    label="Issue"
                    type="textarea"
                    placeholder="Type issue here"
                    inputClassName="!h-24 resize-none"
                    value={issue}
                    onChange={e => {
                      //@ts-expect-error
                      setIssue(e.target.value);
                      console.log(issue);
                    }}
                  />
                  <ListInput
                    dropdown
                    label="Contact (optional)"
                    type="select"
                    defaultValue="twitter"
                    placeholder="Please choose..."
                    value={contact}
                    onChange={e => {
                      //@ts-expect-error
                      setContact(e.currentTarget.value);
                      console.log(contact);
                    }}
                  >
                    <option value="email">Email</option>
                    <option value="telegram">Telegram</option>
                    <option value="twitter">Twitter</option>
                  </ListInput>
                  <ListInput
                    label="Handle (optional)"
                    type="email"
                    placeholder="Your e-mail or username"
                    value={handle}
                    onChange={e => {
                      //@ts-expect-error
                      setHandle(e.target.value);
                      console.log(handle);
                    }}
                  />
                </List>
              </>
            }
            buttons={
              <>
                <DialogButton
                  onClick={() => {
                    return setReportOpened(false);
                  }}
                >
                  Cancel
                </DialogButton>
                <DialogButton
                  strong
                  onClick={() => {
                    fetch("https://wallet.light.so/api/report", {
                      method: "POST",
                      body: JSON.stringify({
                        host,
                        issue,
                        contact,
                        handle,
                      }),
                      headers: new Headers({
                        "Content-Type": "application/json",
                        Accept: "application/json",
                      }),
                    });
                    return setReportOpened(false);
                  }}
                >
                  Report
                </DialogButton>
              </>
            }
            onBackdropClick={() => {
              return setReportOpened(false);
            }}
          />
          <ListItem
            className="hover:bg-gray-300 dark:hover:bg-gray-800 cursor-pointer"
            title="Forget Settings For This Website"
            media={
              <div className="flex justify-center items-center w-5 h-5 bg-pink-600 rounded-md">
                <Trash />
              </div>
            }
            onClick={() => {
              return setForgetOpened(true);
            }}
          />
          <ListItem
            className="hover:bg-gray-300 dark:hover:bg-gray-800 cursor-pointer"
            title="Delete Entire Wallet History"
            media={
              <div className="flex justify-center items-center w-5 h-5 bg-violet-600 rounded-md">
                <EntryLeverKeypadTrianglebadgeExclamationmark />
              </div>
            }
            onClick={() => {
              return setHistoryOpened(true);
            }}
          />
        </List>
        <Block className="flex justify-center">
          <Button
            outline
            large
            rounded
            className="w-32 normal-case"
            onClick={() => {
              window.close();
              if (typeof browser.tabs !== "undefined") {
                (browser.tabs as any).query(
                  {
                    active: true,
                    currentWindow: true,
                  },
                  (tabs: browser.tabs.Tab[]) => {
                    let accountIdPayload = {
                      direction: "from-popup-script",
                      method: "open_windowApp",
                    };
                    logPopup(
                      `==> sendingMessageContent at ${tabId}: ${JSON.stringify(
                        accountIdPayload,
                      )}`,
                    );
                    if (tabs && tabId) {
                      browser.tabs
                        .sendMessage(tabId, accountIdPayload)
                        .then(value => {
                          logPopup(`<== sendingMessageContent: ${value}`);
                        });
                    }
                  },
                );
              }
            }}
          >
            Open Light App
          </Button>
        </Block>
        <BlockHeader className="invisible ml-4 font-semibold">
          {accounts && addresses && shadowAccountIdOption && (
            <div className="flex items-center fill-gray-300">
              <div className="ml-2">
                <select
                  ref={shadowAccountIdRef}
                  // eslint-disable-next-line tailwindcss/no-custom-classname, tailwindcss/classnames-order
                  className="line-clamp-1 inline-block -mr-1.5 ml-2 w-auto max-w-none text-2xl whitespace-nowrap bg-inherit outline-none appearance-none"
                >
                  <option>
                    {decodeURI(accounts[shadowAccountIdOption].name).replace(
                      /%23/g,
                      "#",
                    )}
                  </option>
                </select>
              </div>
            </div>
          )}
        </BlockHeader>
        <List strong inset className="invisible mb-0">
          <ListItem
            title="OptionId"
            after={
              shadowOptionIdOption && (
                <div className="flex items-center fill-gray-300">
                  <select
                    ref={shadowOptionIdRef}
                    className="inline-block mr-2 w-auto max-w-none text-base whitespace-nowrap bg-inherit outline-none appearance-none"
                  >
                    <option>{shadowOptionIdOption}</option>
                  </select>
                </div>
              )
            }
            media={<div className="w-3 h-3 bg-gray-400 rounded-full" />}
          />
          <ListItem
            title="ChainId"
            after={
              shadowChainIdOption && (
                <div className="flex items-center fill-gray-300">
                  <select
                    ref={shadowChainIdRef}
                    className="inline-block mr-2 w-auto max-w-none text-base whitespace-nowrap bg-inherit outline-none appearance-none"
                  >
                    <option>{shadowChainIdOption}</option>
                  </select>
                </div>
              )
            }
            media={<div className="w-3 h-3 bg-gray-400 rounded-full" />}
          />
        </List>
      </div>
      <Dialog
        translucent={false}
        opened={reportOpened}
        title="Light Wallet Issue Report"
        content={
          <>
            <div className="mt-2 mb-4 text-sm">Report {host} not working?</div>
            <List className="my-4">
              <ListInput
                label="Issue"
                type="textarea"
                placeholder="Type issue here"
                inputClassName="!h-24 resize-none"
                value={issue}
                onChange={e => {
                  //@ts-expect-error
                  setIssue(e.target.value);
                  console.log(issue);
                }}
              />
              <ListInput
                dropdown
                label="Contact (optional)"
                type="select"
                defaultValue="twitter"
                placeholder="Please choose..."
                value={contact}
                onChange={e => {
                  //@ts-expect-error
                  setContact(e.currentTarget.value);
                  console.log(contact);
                }}
              >
                <option value="email">Email</option>
                <option value="telegram">Telegram</option>
                <option value="twitter">Twitter</option>
              </ListInput>
              <ListInput
                label="Handle (optional)"
                type="email"
                placeholder="Your e-mail or username"
                value={handle}
                onChange={e => {
                  //@ts-expect-error
                  setHandle(e.target.value);
                  console.log(handle);
                }}
              />
            </List>
          </>
        }
        buttons={
          <>
            <DialogButton
              onClick={() => {
                return setReportOpened(false);
              }}
            >
              Cancel
            </DialogButton>
            <DialogButton
              strong
              onClick={() => {
                fetch("https://wallet.light.so/api/report", {
                  method: "POST",
                  body: JSON.stringify({
                    host,
                    issue,
                    contact,
                    handle,
                  }),
                  headers: new Headers({
                    "Content-Type": "application/json",
                    Accept: "application/json",
                  }),
                });

                return setReportOpened(false);
              }}
            >
              Report
            </DialogButton>
          </>
        }
        onBackdropClick={() => {
          return setReportOpened(false);
        }}
      />
      <Dialog
        translucent={false}
        opened={forgetOpened}
        title={`Forget settings for ${host}`}
        content={
          <div className="my-2 text-sm">
            Do you really want to clear wallet settings for {host}?
          </div>
        }
        buttons={
          <>
            <DialogButton
              onClick={() => {
                return setForgetOpened(false);
              }}
            >
              Cancel
            </DialogButton>
            <DialogButton
              strong
              onClick={() => {
                if (typeof browser.tabs !== "undefined") {
                  (browser.tabs as any).query(
                    {
                      active: true,
                      currentWindow: true,
                    },
                    (tabs: browser.tabs.Tab[]) => {
                      let accountIdPayload = {
                        direction: "from-popup-script",
                        method: "delete_windowHost",
                        params: { host: host },
                      };
                      logPopup(
                        `==> sendingMessageContent at ${tabId}: ${JSON.stringify(
                          accountIdPayload,
                        )}`,
                      );
                      if (tabs && tabId) {
                        browser.tabs
                          .sendMessage(tabId, accountIdPayload)
                          .then(value => {
                            logPopup(`<== sendingMessageContent: ${value}`);
                          });
                      }
                    },
                  );
                }
                return setForgetOpened(false);
              }}
            >
              Forget
            </DialogButton>
          </>
        }
        onBackdropClick={() => {
          return setForgetOpened(false);
        }}
      />
      <Dialog
        translucent={false}
        opened={historyOpened}
        title={`Delete Entire Wallet History`}
        content={
          <div className="my-2 text-sm">
            Do you really want to clear entire wallet settings?
          </div>
        }
        buttons={
          <>
            <DialogButton
              onClick={() => {
                return setHistoryOpened(false);
              }}
            >
              Cancel
            </DialogButton>
            <DialogButton
              strong
              onClick={() => {
                if (typeof browser.tabs !== "undefined") {
                  (browser.tabs as any).query(
                    {
                      active: true,
                      currentWindow: true,
                    },
                    (tabs: browser.tabs.Tab[]) => {
                      let accountIdPayload = {
                        direction: "from-popup-script",
                        method: "delete_windowAccount",
                        params: {},
                      };
                      logPopup(
                        `==> sendingMessageContent at ${tabId}: ${JSON.stringify(
                          accountIdPayload,
                        )}`,
                      );
                      if (tabs && tabId) {
                        browser.tabs
                          .sendMessage(tabId, accountIdPayload)
                          .then(value => {
                            logPopup(`<== sendingMessageContent: ${value}`);
                          });
                      }
                    },
                  );
                }
                return setHistoryOpened(false);
              }}
            >
              Forget
            </DialogButton>
          </>
        }
        onBackdropClick={() => {
          return setHistoryOpened(false);
        }}
      />
    </div>
  );
}
