import clsx from "clsx";
import { AnimatePresence, motion, LayoutGroup } from "framer-motion";
import Link from "next/link";
import { useState } from "react";

export default function Store() {
  let [hoveredIndex, setHoveredIndex] = useState<number>(0);

  return (
    <div className="flex min-w-[320px] justify-center">
      <div className="w-full max-w-lg">
        <nav className="mt-11 flex gap-8">
          <LayoutGroup id="nav">
            {[
              ["New To Dapps", "#features"],
              ["Trending", "#reviews"],
              ["Exchanges", "#pricing"],
              ["NFT Marketplaces", "#faqs"],
            ].map(([label, href], index) => {
              return (
                <Link
                  key={label}
                  href={href}
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
                        animate={{ opacity: 1, transition: { duration: 0.15 } }}
                        exit={{
                          opacity: 0,
                          transition: { duration: 0.15, delay: 0.2 },
                        }}
                      />
                    )}
                  </AnimatePresence>
                  <span className="relative z-10">{label}</span>
                </Link>
              );
            })}
          </LayoutGroup>
        </nav>
        <main className="w-full">
          <AnimatePresence>
            <motion.div
              key={hoveredIndex ? "ssdf" : "empty"}
              className="text-3xl"
              initial={{ y: 10, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              exit={{ y: -10, opacity: 0 }}
              transition={{ duration: 0.2 }}
            >
              {hoveredIndex === 1 ? "asdf" : "😋"}
            </motion.div>
          </AnimatePresence>
        </main>
      </div>
    </div>
  );
}
