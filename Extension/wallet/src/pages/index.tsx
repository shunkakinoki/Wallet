import { Page, Button } from "konsta/react";
import { useEffect, useState } from "react";

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
      <div className="container flex flex-col justify-center px-3 mx-auto max-w-md h-screen max-h-screen">
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
        <div className="my-20">
          <div className="flex justify-center">
            <span className="inline-flex items-center py-0.5 px-2.5 text-sm font-medium text-indigo-800 bg-indigo-100 rounded-md">
              <svg
                className="mr-1.5 -ml-0.5 w-2 h-2 text-indigo-600"
                fill="currentColor"
                viewBox="0 0 8 8"
              >
                <circle cx={4} cy={4} r={3} />
              </svg>
              Step {step}
            </span>
          </div>
          <div className="my-5 text-center">
            <h1 className="text-2xl font-bold">
              {step === 1 && "Enable the extension"}
            </h1>
          </div>
          {(step === 1 || step === 2) && (
            // eslint-disable-next-line jsx-a11y/media-has-caption
            <video
              autoPlay
              loop
              src={`/step_${step}.mov`}
              className="rounded-md"
            />
          )}
        </div>
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
