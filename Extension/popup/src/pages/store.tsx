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
        <main className="mt-4 w-full">
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
                    "flex w-full space-x-5 overflow-x-scroll",
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
                          <div className="pr-2 text-sm">{dapp.name}</div>
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
                  className="h-[30rem] w-[18rem] cursor-pointer rounded-md"
                  title="iframe"
                  //@ts-expect-error
                  src={selectedDapp?.site}
                />
                <div className="space-y-8">
                  <h1 className="text-3xl font-bold tracking-tight text-indigo-400 ">
                    <Balancer>
                      {/* @ts-expect-error */}
                      {selectedDapp?.name}
                    </Balancer>
                  </h1>
                  <button
                    type="button"
                    className="inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                    onClick={() => {
                      //@ts-expect-error
                      window.open(selectedDapp?.site);
                    }}
                  >
                    <GlobeAltIcon
                      className="-ml-1 mr-3 h-5 w-5"
                      aria-hidden="true"
                    />
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
