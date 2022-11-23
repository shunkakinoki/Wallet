import { clsx } from "clsx";
import { Page } from "konsta/react";
import Image from "next/future/image";
import { useEffect, useState } from "react";

import { CheckIcon } from "../components/CheckIcon";
import { CircleIcon } from "../components/CircleIcon";
import { ExtensionIcon } from "../components/ExtensionIcon";

export default function Home() {
  const [isSafari, setIsSafari] = useState(false);
  const [step, setStep] = useState(1);
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
      <div className="container flex flex-col justify-center px-3 my-12 mx-auto max-w-md max-h-screen">
        <div className="my-8 text-center">
          <h1 className="text-3xl font-bold">
            Enabling the{" "}
            <strong className="font-extrabold text-indigo-400">
              Light Wallet
            </strong>{" "}
            <br />
            Safari extension
          </h1>
          <h3 className="mt-3">
            Install the Testflight{" "}
            <a
              className="font-extrabold text-indigo-400 hover:underline"
              href={"https://testflight.apple.com/join/4bbpvn9a"}
              target="_blank"
              rel="noreferrer"
            >
              here
            </a>
          </h3>
          <p className="mt-4 text-sm">
            {isSafari
              ? "That's step 1 done! You're almost there."
              : "Please switch to Safari to proceed."}
          </p>
        </div>
        {/* eslint-disable-next-line jsx-a11y/media-has-caption */}
        <video autoPlay loop src={`/step_${step}.mov`} />
        <div className="mt-12 text-sm font-medium text-center text-gray-500 dark:text-gray-300">
          <p>
            Trouble enabling Light Wallet Extension? <br />
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
