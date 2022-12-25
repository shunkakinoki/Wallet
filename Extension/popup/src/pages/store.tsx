/* eslint-disable @next/next/no-img-element */
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
import { useEffect, useMemo, useState } from "react";
import useSWR from "swr";

import s from "./store.module.css";

const fetcher = (...args: any[]) => {
  //@ts-expect-error
  return fetch(...args).then(res => {
    return res.json();
  });
};

const supportLinks = [
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
  let [hoveredIndex, setHoveredIndex] = useState<number>(0);
  const { data } = useSWR("https://wallet.light.so/api/dapp", fetcher);
  const [tabs, setTabs] = useState<any[]>([]);
  const [links, setLinks] = useState<any[]>(supportLinks);

  const items = useMemo(() => {
    if (data) {
      return data.dapps.filter((d: any) => {
        return d.type === supportLinks[hoveredIndex].type;
      });
    }
    return [];
  }, [data, hoveredIndex]);

  useEffect(() => {
    setTabs(items);
  }, [items]);

  return (
    <div className="flex justify-center">
      <div className="max-w-lg flex-col">
        <div
          className={clsx(
            "flex w-full overflow-x-scroll border-b border-gray-400",
            hoveredIndex === 0
              ? s.left
              : hoveredIndex === supportLinks.length - 1
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
                values={links}
                onReorder={setLinks}
              >
                <AnimatePresence>
                  {links.map((link, index) => {
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
                            "relative -my-2 -mx-3 cursor-pointer rounded-lg px-3 py-2 text-sm text-gray-700 transition-colors delay-150 hover:text-gray-900 hover:delay-[0ms]",
                            hoveredIndex === index && "bg-gray-200",
                          )}
                          onClick={() => {
                            return setHoveredIndex(index);
                          }}
                          onMouseEnter={() => {
                            return setHoveredIndex(index);
                          }}
                        >
                          {hoveredIndex === index && (
                            <motion.span
                              className="absolute inset-0 rounded-lg bg-gray-100"
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
                  })}
                </AnimatePresence>
              </Reorder.Group>
            </LayoutGroup>
          </nav>
        </div>
        <main className="mt-4 w-full">
          <LayoutGroup id="tabs">
            <Reorder.Group
              layoutScroll
              as="ul"
              axis="x"
              values={tabs}
              onReorder={setTabs}
            >
              <AnimatePresence>
                <ul className="flex space-x-6 overflow-x-scroll">
                  {tabs?.map((dapp: any) => {
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
                        <div
                          key={dapp.site}
                          className="flex items-center rounded-3xl border border-gray-500"
                        >
                          <img
                            className="m-1 h-6 w-6 rounded-full"
                            src={dapp.icon}
                            alt=""
                          />
                          <div className="pr-2 text-sm">{dapp.name}</div>
                        </div>
                      </Reorder.Item>
                    );
                  })}
                </ul>
              </AnimatePresence>
            </Reorder.Group>
            <AnimatePresence mode="popLayout">
              <motion.div
                key={supportLinks[hoveredIndex].name}
                className="mt-4 text-lg text-gray-600"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
              >
                {supportLinks[hoveredIndex].description}
              </motion.div>
            </AnimatePresence>
            {data && (
              <iframe
                className="mt-4 h-[36rem] rounded-md"
                title="iframe"
                src={
                  data.dapps.filter((d: any) => {
                    return d.type === supportLinks[hoveredIndex].type;
                  })[0].site
                }
              />
            )}
          </LayoutGroup>
        </main>
      </div>
    </div>
  );
}
