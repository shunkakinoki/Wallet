/* eslint-disable @next/next/no-img-element */
import { GlobeAltIcon } from "@heroicons/react/20/solid";
import {
  BeakerIcon,
  BriefcaseIcon,
  BuildingStorefrontIcon,
  FaceSmileIcon,
  CubeTransparentIcon,
  FireIcon,
  ScaleIcon,
} from "@heroicons/react/24/outline";
import clsx from "clsx";
import { AnimatePresence, motion, LayoutGroup, Reorder } from "framer-motion";
import { Block, Button } from "konsta/react";
import Link from "next/link";
import { useEffect, useMemo, useState, useRef, useCallback } from "react";
import Balancer from "react-wrap-balancer";
import useSWR from "swr";

import s from "./store.module.css";

const fetcher = (...args: any[]) => {
  //@ts-expect-error
  return fetch(...args).then(res => {
    return res.json();
  });
};

const initialTabs = [
  {
    name: "New",
    href: "#",
    description: "New Dapps to try out across the ecosystem.",
    icon: BeakerIcon,
    type: "mint",
  },
  {
    name: "Trending",
    href: "#",
    description: "Trending Dapps curated from Light users.",
    icon: FireIcon,
    type: "trending",
  },
  {
    name: "Bridge",
    href: "#",
    description:
      "Move assets between different layers of Ethereum by bridging them across.",
    icon: BriefcaseIcon,
    type: "bridge",
  },
  {
    name: "Mint",
    href: "#",
    description:
      "Find new art, music & cultural objects to mint into existence.",
    icon: CubeTransparentIcon,
    type: "mint",
  },
  {
    name: "NFT",
    href: "#",
    description: "Place bids on existing NFTs that you want to buy.",
    icon: BuildingStorefrontIcon,
    type: "nft",
  },
  {
    name: "Swap",
    href: "#",
    description:
      "Swap tokens on Ethereum & other networks using decentralized exchanges, which are known as DEXs.",
    icon: ScaleIcon,
    type: "swap",
  },
  {
    name: "Social",
    href: "#",
    description:
      "Interact with next-generation of blockchain social apps that assures your data ownership.",
    icon: FaceSmileIcon,
    type: "social",
  },
];

export default function Store() {
  const { data } = useSWR("https://wallet.light.so/api/dapp", fetcher);

  const [selectedDapp, setSelectedDapp] = useState();
  const [selectedLink, setSelectedLink] = useState<number>(0);
  const [links, setLinks] = useState<any[]>([]);
  const [selectedTab, setSelectedTab] = useState<number>(0);
  const [tabs, setTabs] = useState(initialTabs);

  const [isEdit, setIsEdit] = useState(false);

  const items = useMemo(() => {
    if (data) {
      return data.dapps.filter((d: any) => {
        return d.type === initialTabs[selectedTab].type;
      });
    }
    return [];
  }, [data, selectedTab]);

  useEffect(() => {
    setSelectedDapp(items[0]);
    setLinks(items);
  }, [items]);

  //Code rom: https://github.com/springload/react-iframe-click/blob/master/src/index.tsx
  const iframeRef = useRef<null | HTMLIFrameElement>(null);

  const iframeCallbackRef = useCallback(
    (node: null | HTMLIFrameElement): void => {
      iframeRef.current = node;
    },
    [],
  );

  useEffect(() => {
    const onBlur = () => {
      if (
        document.activeElement &&
        document.activeElement.nodeName.toLowerCase() === "iframe" &&
        iframeRef.current &&
        iframeRef.current === document.activeElement
      ) {
        //@ts-expect-error
        window.open(selectedDapp?.site);
      }
    };

    window.addEventListener("blur", onBlur);

    return () => {
      window.removeEventListener("blur", onBlur);
    };
    //@ts-expect-error
  }, [selectedDapp?.site]);

  return (
    <div className="flex min-w-[320px] justify-center">
      <div className="w-full max-w-lg flex-col">
        <div
          className={clsx(
            "flex w-full overflow-x-scroll border-b border-gray-400 dark:border-gray-600",
            selectedTab === 0
              ? s.left
              : selectedTab === initialTabs.length - 1
              ? s.right
              : s.scroll,
          )}
        >
          <nav className="mx-4 mt-5 mb-4 flex">
            <LayoutGroup id="nav">
              <Reorder.Group
                layoutScroll
                className="flex gap-8"
                as="div"
                axis="x"
                values={tabs}
                onReorder={setTabs}
              >
                <AnimatePresence>
                  {isEdit
                    ? tabs.map((link, index) => {
                        return (
                          <Reorder.Item
                            key={link.name}
                            as="div"
                            value={link}
                            id={link.name}
                            initial={{ opacity: 0.3 }}
                            animate={{
                              opacity: 1,
                              y: 0,
                              transition: { duration: 0.15 },
                            }}
                            exit={{
                              opacity: 0,
                              y: 20,
                              transition: { duration: 0.3 },
                            }}
                          >
                            <button
                              className={clsx(
                                "relative -my-2 -mx-3 cursor-pointer rounded-lg px-3 py-2 text-sm text-gray-700 transition-colors delay-150 hover:text-gray-900 hover:delay-[0ms] dark:text-gray-400 dark:hover:text-gray-300",
                                selectedTab === index &&
                                  "bg-gray-200 dark:text-gray-800",
                              )}
                              onClick={() => {
                                return setSelectedTab(index);
                              }}
                              onMouseEnter={() => {
                                return setSelectedTab(index);
                              }}
                            >
                              {selectedTab === index && (
                                <motion.span
                                  className="absolute inset-0 rounded-lg bg-gray-100 dark:text-gray-900"
                                  layoutId="hoverTab"
                                  initial={{ opacity: 0 }}
                                  animate={{
                                    opacity: 1,
                                    transition: { duration: 0.15 },
                                  }}
                                  exit={{
                                    opacity: 0,
                                    transition: { duration: 0.15, delay: 0.2 },
                                  }}
                                />
                              )}
                              <div className="relative z-10 flex items-center">
                                <link.icon
                                  className="mr-2 h-4 w-4"
                                  aria-hidden="true"
                                />
                                {link.name}
                              </div>
                            </button>
                          </Reorder.Item>
                        );
                      })
                    : tabs.map((link, index) => {
                        return (
                          <button
                            key={link.name}
                            className={clsx(
                              "relative -my-2 -mx-3 cursor-pointer rounded-lg px-3 py-2 text-sm text-gray-700 transition-colors delay-150 hover:text-gray-900 hover:delay-[0ms] dark:text-gray-400",
                              selectedTab === index &&
                                "bg-gray-200 dark:text-gray-800",
                            )}
                            onClick={() => {
                              return setSelectedTab(index);
                            }}
                            onMouseEnter={() => {
                              return setSelectedTab(index);
                            }}
                          >
                            {selectedTab === index && (
                              <motion.span
                                className="absolute inset-0 rounded-lg bg-gray-100 dark:text-gray-900"
                                layoutId="hoverTab"
                                initial={{ opacity: 0 }}
                                animate={{
                                  opacity: 1,
                                  transition: { duration: 0.15 },
                                }}
                                exit={{
                                  opacity: 0,
                                  transition: { duration: 0.15, delay: 0.2 },
                                }}
                              />
                            )}
                            <div className="relative z-10 flex items-center">
                              <link.icon
                                className="mr-2 h-4 w-4"
                                aria-hidden="true"
                              />
                              {link.name}
                            </div>
                          </button>
                        );
                      })}
                </AnimatePresence>
              </Reorder.Group>
            </LayoutGroup>
          </nav>
        </div>
        <main className="mt-4 w-full px-3">
          <LayoutGroup id="links">
            <Reorder.Group
              layoutScroll
              as="ul"
              axis="x"
              values={links}
              onReorder={setLinks}
            >
              <AnimatePresence>
                <ul
                  className={clsx(
                    "flex w-full space-x-4 overflow-x-scroll",
                    selectedLink === 0 ? s.left : s.scroll,
                  )}
                >
                  {links?.map((dapp, index) => {
                    return (
                      <Reorder.Item
                        key={dapp.site}
                        value={dapp}
                        id={dapp.site}
                        initial={{ opacity: 0.3 }}
                        animate={{
                          opacity: 1,
                          y: 0,
                          transition: { duration: 0.15 },
                        }}
                        exit={{
                          opacity: 0,
                          y: 20,
                          transition: { duration: 0.3 },
                        }}
                      >
                        <button
                          key={dapp.site}
                          className={clsx(
                            "flex items-center rounded-3xl border border-gray-400 transition-colors duration-100 dark:border-gray-600",
                            selectedLink === index &&
                              "bg-gray-100 dark:text-gray-800",
                          )}
                          onClick={() => {
                            setSelectedDapp(dapp);
                            return setSelectedLink(index);
                          }}
                        >
                          <img
                            className="m-1 h-6 w-6 rounded-full"
                            src={dapp.icon}
                            alt=""
                          />
                          <div className="pr-2 text-xs">{dapp.name}</div>
                        </button>
                      </Reorder.Item>
                    );
                  })}
                </ul>
              </AnimatePresence>
            </Reorder.Group>
            <AnimatePresence mode="popLayout">
              <motion.div
                key={initialTabs[selectedTab].name}
                className="mt-4 text-lg text-gray-600 dark:text-gray-400"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
              >
                {initialTabs[selectedTab].description}
              </motion.div>
            </AnimatePresence>
            {data && (
              <div className="mt-4 flex gap-8">
                <iframe
                  ref={iframeCallbackRef}
                  className="xs:w-[50vw] h-[60vh] w-[55vw] cursor-pointer rounded-md md:h-[30rem] md:w-[18rem]"
                  title="iframe"
                  //@ts-expect-error
                  src={selectedDapp?.site}
                />
                <div className="space-y-8">
                  <h1 className="text-2xl font-bold tracking-tight text-indigo-400 ">
                    <Balancer>
                      {/* @ts-expect-error */}
                      {selectedDapp?.name}
                    </Balancer>
                  </h1>
                  <button
                    type="button"
                    className="inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-2 py-1 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                    onClick={() => {
                      //@ts-expect-error
                      window.open(selectedDapp?.site);
                    }}
                  >
                    <svg
                      className="-ml-1 mr-3 h-5 w-5 fill-white"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 64 64"
                      aria-labelledby="title"
                      aria-describedby="desc"
                      role="img"
                    >
                      <path d="M33 4a31.453 31.453 0 0 0-4.4.3.1.1 0 0 0-.1-.1 2.283 2.283 0 0 0 1-2.3C29.3.7 28.2 0 26.6 0a3.4 3.4 0 0 0-1 .1c-1.9.4-3.1 1.8-2.8 3.2A2.549 2.549 0 0 0 24.7 5v.2A29.912 29.912 0 1 0 33 4zm-9.2-.9c-.2-.8.8-1.7 2.1-2a1.7 1.7 0 0 1 .7-.1c1 0 1.8.4 1.9 1a1.5 1.5 0 0 1-.7 1.4 2.129 2.129 0 0 0-1.6-.3 2.072 2.072 0 0 0-1.3.9 1.473 1.473 0 0 1-1.1-.9zm25.3 47a23.545 23.545 0 0 1-9.7 5.8l-2.6-4.3-.7 5a30.285 30.285 0 0 1-3.1.2 22.619 22.619 0 0 1-16.1-6.7 23.545 23.545 0 0 1-5.8-9.7l4.3-2.6-5-.7a30.284 30.284 0 0 1-.2-3.1 22.619 22.619 0 0 1 6.7-16.1 23.545 23.545 0 0 1 9.7-5.8l2.6 4.3.7-5a30.284 30.284 0 0 1 3.1-.2 22.619 22.619 0 0 1 16.1 6.7 23.545 23.545 0 0 1 5.8 9.7l-4.3 2.7 5 .7a30.285 30.285 0 0 1 .2 3.1 22.562 22.562 0 0 1-6.7 16zm-.5-31.7l-12.3 9.4a6.109 6.109 0 0 0-3-.8l-3.2-6.7-.2 7.4a7.231 7.231 0 0 0-2.2 1.7L23.8 28l2.9 3a8.279 8.279 0 0 0-.7 2.7l-6.7 3.2 7.4.2a.1.1 0 0 0 .1.1l-9.4 12.3 12.3-9.4a6.109 6.109 0 0 0 3 .8l3.2 6.7.2-7.4a7.231 7.231 0 0 0 2.2-1.7l3.9 1.4-2.9-3a8.279 8.279 0 0 0 .7-2.7l6.7-3.2-7.4-.2a.1.1 0 0 0-.1-.1zM33 27.8zm-1.2.3A4.869 4.869 0 0 1 33 28h.8a9.363 9.363 0 0 1 1.6.4l-4.5 3.4-3.4 4.5a3.545 3.545 0 0 1-.3-1.1 5.869 5.869 0 0 1 4.6-7.1zm4.3 11a10.837 10.837 0 0 1-1.9.8 4.868 4.868 0 0 1-1.2.1h-.8a9.363 9.363 0 0 1-1.6-.4l4.5-3.4 3.4-4.5a3.545 3.545 0 0 1 .3 1.1 5.854 5.854 0 0 1-2.7 6.3z" />
                    </svg>
                    Open in Safari
                  </button>
                </div>
              </div>
            )}
          </LayoutGroup>
        </main>
        <Block className="flex justify-center">
          <Link href="/">
            <Button outline large rounded className="w-32 normal-case">
              Go Home
            </Button>
          </Link>
        </Block>
      </div>
    </div>
  );
}
