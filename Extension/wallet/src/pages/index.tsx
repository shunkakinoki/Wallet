import { Page } from "konsta/react";
import { useEffect, useMemo, useState } from "react";
import ReactConfetti from "react-confetti";
import create from "zustand";
import { persist } from "zustand/middleware";

interface StepState {
  step: number;
  setStep: (newStep: number) => void;
}

export const useUserStep = create(
  persist<StepState>(
    (set, get) => {
      return {
        step: 1,
        setStep: newStep => {
          return set(() => {
            return { step: newStep };
          });
        },
      };
    },
    {
      name: "@lightdotso/wallet",
    },
  ),
);

export default function Home() {
  const [isSafari, setIsSafari] = useState(false);
  const [isMounted, setIsMounted] = useState(false);
  const [isEnabled, setIsEnabled] = useState(false);

  const [sstep, setStep] = useUserStep(state => {
    return [state.step, state.setStep];
  });

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

  useEffect(() => {
    setIsMounted(true);
  }, []);

  const step = useMemo(() => {
    if (isMounted) {
      return sstep;
    }
    return 1;
  }, [isMounted, sstep]);

  return (
    <Page>
      <title>Light Wallet</title>
      <div className="container flex flex-col justify-center px-3 mx-auto max-w-md h-screen max-h-screen">
        {isEnabled && <ReactConfetti />}
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
              {step === 2 && "Allow website permissions"}
              {step === 3 && "Test wallet connection"}
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
          {step === 3 && (
            <div className="flex justify-center">
              {/* eslint-disable-next-line jsx-a11y/alt-text, @next/next/no-img-element */}
              <img src="/logo.png" className="w-52 rounded-full" />
            </div>
          )}
        </div>
        <div className="mt-12 w-full text-sm font-medium text-center text-gray-500 dark:text-gray-300">
          <div className="flex justify-center mb-4 text-center">
            <button
              type="button"
              className="py-3 w-full text-lg text-indigo-700 bg-indigo-100 hover:bg-indigo-200 rounded-md border border-transparent focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              onClick={async () => {
                if (step === 1 || step === 2) {
                  setStep(step + 1);
                } else {
                  if (window.ethereum) {
                    try {
                      const accounts = await window?.ethereum.request({
                        method: "eth_requestAccounts",
                      });
                      if (accounts && accounts.length > 0) {
                        if (isEnabled) {
                          setStep(1);
                          setIsEnabled(false);
                        }
                        setIsEnabled(true);
                      }
                    } catch (error) {
                      console.error(error);
                    }
                  }
                }
              }}
            >
              {step === 1 && "I've enabled the extension"}
              {step === 2 && "I've allowed website permissions"}
              {step === 3 && "Testing wallet connection"}
            </button>
          </div>
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
