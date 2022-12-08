import { clsx } from "clsx";
import { Page } from "konsta/react";
import Image from "next/image";
import { useEffect, useState } from "react";

import { CheckIcon } from "../components/CheckIcon";
import { CircleIcon } from "../components/CircleIcon";
import { ExtensionIcon } from "../components/ExtensionIcon";

export default function Home() {
  const [isSafari, setIsSafari] = useState(false);
  const [isButton, setIsButton] = useState(false);
  const [isEnabled, setIsEnabled] = useState(false);

  useEffect(() => {
    if (typeof window !== "undefined") {
      let chromeAgent = window.navigator.userAgent.indexOf("Chrome") > -1;
      let safariAgent = window.navigator.userAgent.indexOf("Safari") > -1;
      if (chromeAgent && safariAgent) {
        safariAgent = false;
      }
      setIsSafari(safariAgent);
    }
  }, []);

  return (
    <Page>
      <title>Light Wallet</title>
      <div className="container px-3 my-12 mx-auto max-w-md">
        <div className="my-8 text-center">
          <h1 className="text-3xl font-bold">
            Enabling the{" "}
            <strong className="font-extrabold text-indigo-400">
              Light Wallet
            </strong>{" "}
            <br />
            Safari extension
          </h1>
          <p className="mt-2 text-sm">
            {isSafari
              ? "That's step 1 done! You're almost there."
              : "Please switch to Safari to proceed."}
          </p>
        </div>
        <div className="flex my-6">
          {isSafari ? (
            <div className="flex shrink-0 justify-center items-center p-0.5 mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-gray-400 rounded-full border-2 border-gray-400">
              <CheckIcon />
            </div>
          ) : (
            <div className="flex shrink-0 justify-center items-center mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-indigo-700 rounded-full border-2 border-indigo-700">
              <p>1</p>
            </div>
          )}
          <div className={clsx(isSafari && "text-gray-600")}>
            {isSafari ? "Open Safari - That's done!" : "Open Safari Browser"}
          </div>
        </div>
        <div className="flex my-6">
          <div className="flex shrink-0 justify-center items-center mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-indigo-700 rounded-full border-2 border-indigo-700">
            <p>2</p>
          </div>
          <div>
            Tap the <span className="font-bold text-indigo-400">aA</span> or{" "}
            <ExtensionIcon />
            in the address bar
            <div>
              <Image
                className="mt-4 rounded-md ring-4 ring-gray-300 shadow"
                src="/extension_button.jpg"
                alt="Extension Button"
                height={45}
                width={300}
              />
            </div>
            <div className="mt-2 text-sm">
              Can&apos;t find the <ExtensionIcon /> button? You may have to use
              the <CircleIcon />
              or <span className="font-bold text-indigo-400">aA</span> button
              instead.{" "}
              <button
                className="text-indigo-400 underline"
                onClick={() => {
                  setIsButton(!isButton);
                }}
              >
                Read more.
              </button>
            </div>
            {isButton && (
              <div className="py-3 px-5 mt-2 text-sm bg-gray-300 dark:bg-gray-700 rounded-md">
                Depending on your screen size and Safari settings, the{" "}
                <ExtensionIcon /> may be replaced by either a{" "}
                <span className="font-bold text-indigo-400">aA</span> or{" "}
                <CircleIcon /> that shows up in the same place, the right of the
                address bar. Use that button instead, the other steps will
                remain the same.
              </div>
            )}
          </div>
        </div>
        <div className="flex my-6">
          <div className="flex shrink-0 justify-center items-center mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-indigo-700 rounded-full border-2 border-indigo-700">
            <p>3</p>
          </div>
          <div>
            Tap{" "}
            <strong className="text-indigo-400">
              Manage Extensions <ExtensionIcon />
            </strong>
            from the toolbar
            <div>
              <Image
                className="mt-4 rounded-md ring-4 ring-gray-300 shadow"
                src="/manage_extensions.jpg"
                alt="Manage Extensions"
                height={45}
                width={300}
              />
            </div>
          </div>
        </div>
        <div className="flex my-6">
          <div className="flex shrink-0 justify-center items-center mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-indigo-700 rounded-full border-2 border-indigo-700">
            <p>4</p>
          </div>
          <div>
            Enable <strong className="text-indigo-400">Light Wallet</strong> and
            tap <strong className="text-indigo-400">Done</strong>
            <div className="mt-2 text-sm">
              Is the Light toggle disabled and grayed out? You may have to
              briefly turn off Web Restrictions.{" "}
              <button
                className="text-indigo-400 underline"
                onClick={() => {
                  setIsEnabled(!isEnabled);
                }}
              >
                Read more.
              </button>
            </div>
            {isEnabled && (
              <div className="py-3 px-5 mt-2 text-sm bg-gray-300 dark:bg-gray-700 rounded-md">
                iOS doesn’t let you enable Safari Extensions when Web
                Restrictions are enabled. You can check if you have these
                enabled in the{" "}
                <span className="bg-gray-400 dark:bg-gray-800">
                  Settings app &gt; Screen Time &gt; Content & Privacy
                  Restrictions &gt; Content Restrictions &gt; Web Content
                </span>
                .
                <br />
                <br />
                If possible, please briefly turn these restrictions off, and
                enable Light. You can then safely turn the web restrictions back
                on, Light will keep working.
                <br />
                <br /> If this doesn&apos;t work or if you&apos;d like more
                info, please{" "}
                <a
                  className="text-indigo-400 underline"
                  target="_blank"
                  href="https://twitter.com/Light_Wallet"
                  rel="noreferrer"
                >
                  contact Support
                </a>
                .
              </div>
            )}
          </div>
        </div>
        <div className="flex my-6">
          <div className="flex shrink-0 justify-center items-center mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-indigo-700 rounded-full border-2 border-indigo-700">
            <p>5</p>
          </div>
          <div>
            Tap <strong className="text-indigo-400">Light Wallet</strong>
          </div>
        </div>
        <div className="flex my-6">
          <div className="flex shrink-0 justify-center items-center mt-0.5 mr-2 w-5 h-5 text-sm font-semibold text-indigo-700 rounded-full border-2 border-indigo-700">
            <p>6</p>
          </div>
          <div>
            Tap <strong className="text-indigo-400">Always Allow...</strong> and
            then{" "}
            <strong className="text-indigo-400">
              Always Allow on Every Website
            </strong>
          </div>
        </div>
        <div className="mt-5 text-sm font-medium text-center text-gray-500 dark:text-gray-300">
          <p>
            Troube enabling Light Wallet Extension? <br />
            <a
              className="underline"
              target="_blank"
              href="https://twitter.com/Light_Wallet"
              rel="noreferrer"
            >
              Contact Support
            </a>
          </p>
        </div>
      </div>
    </Page>
  );
}
