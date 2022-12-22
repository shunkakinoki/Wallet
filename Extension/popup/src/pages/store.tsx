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
import { AnimatePresence, motion, LayoutGroup } from "framer-motion";
import Link from "next/link";
import { useState } from "react";

import s from "./store.module.css";

const supportLinks = [
  {
    name: "New",
    href: "#",
    description: "New Dapps to try out across the ecosystem.",
    icon: BeakerIcon,
  },
  {
    name: "Trending",
    href: "#",
    description: "Trending Dapps curated from Light users.",
    icon: FireIcon,
  },
  {
    name: "Bridge",
    href: "#",
    description:
      "Move assets between different layers of Ethereum by bridging them across.",
    icon: BriefcaseIcon,
  },
  {
    name: "Mint",
    href: "#",
    description:
      "Find new art, music & cultural objects to mint into existence.",
    icon: CubeTransparentIcon,
  },
  {
    name: "NFT",
    href: "#",
    description: "Place bids on existing NFTs that you want to buy.",
    icon: BuildingStorefrontIcon,
  },
  {
    name: "Swap",
    href: "#",
    description:
      "Swap tokens on Ethereum & other networks using decentralized exchanges, which are known as DEXs.",
    icon: ScaleIcon,
  },
  {
    name: "Social",
    href: "#",
    description:
      "Interact with next-generation of blockchain social apps that assures your data ownership.",
    icon: FaceSmileIcon,
  },
];

export default function Store() {
  let [hoveredIndex, setHoveredIndex] = useState<number>(0);

  return (
    <div className="flex justify-center">
      <div className="max-w-lg flex-col">
        <div
          className={clsx(
            "flex w-full overflow-x-scroll border-b border-gray-400",
            hoveredIndex < 3
              ? s.left
              : hoveredIndex === supportLinks.length - 1
              ? s.right
              : s.scroll,
          )}
        >
          <nav className="mx-4 mt-5 mb-4 flex gap-8">
            <LayoutGroup id="nav">
              {supportLinks.map((link, index) => {
                return (
                  <Link
                    key={link.href}
                    href={link.href}
                    className={clsx(
                      "relative -my-2 -mx-3 rounded-lg px-3 py-2 text-sm text-gray-700 transition-colors delay-150 hover:text-gray-900 hover:delay-[0ms]",
                      hoveredIndex === index && "bg-gray-200",
                    )}
                    onMouseEnter={() => {
                      return setHoveredIndex(index);
                    }}
                  >
                    <AnimatePresence>
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
                    </AnimatePresence>
                    <div className="relative z-10 flex items-center">
                      <link.icon className="mr-2 h-4 w-4" aria-hidden="true" />
                      {link.name}
                    </div>
                  </Link>
                );
              })}
            </LayoutGroup>
          </nav>
        </div>
        <main className="mt-12 w-full">
          <AnimatePresence mode="popLayout">
            <motion.div
              key={supportLinks[hoveredIndex].name}
              className="text-lg text-gray-600"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.3 }}
            >
              {supportLinks[hoveredIndex].description}
            </motion.div>
          </AnimatePresence>
        </main>
      </div>
    </div>
  );
}
