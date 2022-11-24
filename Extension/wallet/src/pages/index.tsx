// eslint-disable-next-line import/no-named-as-default
import clsx from "clsx";
import { Page } from "konsta/react";
import { useEffect, useMemo, useState } from "react";
// eslint-disable-next-line import/no-named-as-default
import ReactConfetti from "react-confetti";
// eslint-disable-next-line import/no-named-as-default
import toast, { Toaster } from "react-hot-toast";
import { Swiper, SwiperSlide, useSwiper } from "swiper/react";
import create from "zustand";
import { persist } from "zustand/middleware";

import { CarouselButton } from "../components/CarouselButton";

interface StepState {
  step: number;
  setStep: (newStep: number) => void;
}

export const useUserStep = create(
  persist<StepState>(
    (set, get) => {
      return {
        step: 0,
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

  const [swiper, setSwiper] = useState(undefined);

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
    return 0;
  }, [isMounted, sstep]);

  return (
    <Page>
      <title>Light Wallet</title>
      <div className="container flex flex-col justify-between px-3 mx-auto max-w-md h-[85vh] xl:h-4/6 max-h-screen">
        {isEnabled && <ReactConfetti />}
        <div className="mt-8 text-center">
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
          {!isSafari && (
            <p className="mt-3 text-sm">
              Please switch to iOS Safari to proceed.
            </p>
          )}
        </div>
        <div className="my-4">
          <div className="flex justify-center">
            <span className="inline-flex items-center py-0.5 px-2.5 text-sm font-medium text-indigo-800 bg-indigo-100 rounded-md">
              <svg
                className="mr-1.5 -ml-0.5 w-2 h-2 text-indigo-600"
                fill="currentColor"
                viewBox="0 0 8 8"
              >
                <circle cx={4} cy={4} r={3} />
              </svg>
              Step {step + 1}
            </span>
          </div>
          <div className="my-5 text-center">
            <h1
              className={clsx(
                "text-2xl font-bold",
                isEnabled && "text-emerald-300",
              )}
            >
              {step === 0 && "Enable the extension"}
              {step === 1 && "Allow website permissions"}
              {step === 2 && isEnabled && "Success!"}
              {step === 2 && !isEnabled && "Test wallet connection"}
            </h1>
          </div>
          <div className="block relative w-full">
            <Swiper
              initialSlide={0}
              slidesPerView={1}
              pagination={{ clickable: true }}
              scrollbar={{ draggable: true }}
              mousewheel={{
                forceToAxis: true,
              }}
              onSwiper={swiper => {
                //@ts-expect-error
                setSwiper(swiper);
              }}
              onSlideChange={s => {
                setStep(s.realIndex);
              }}
            >
              <SwiperSlide key={0}>
                {/* eslint-disable-next-line jsx-a11y/media-has-caption */}
                <video
                  autoPlay
                  loop
                  controls
                  src={`/step_1.mov`}
                  className="rounded-md"
                />
              </SwiperSlide>
              <SwiperSlide key={1}>
                {/* eslint-disable-next-line jsx-a11y/media-has-caption */}
                <video
                  autoPlay
                  loop
                  controls
                  src={`/step_2.mov`}
                  className="rounded-md"
                />
              </SwiperSlide>
              <SwiperSlide key={2}>
                <div className="flex shrink-0 justify-center">
                  {/* eslint-disable-next-line jsx-a11y/alt-text, @next/next/no-img-element */}
                  <img src="/logo.png" className="w-52 rounded-full" />
                </div>
              </SwiperSlide>
              <CarouselButton index={step} />
            </Swiper>
          </div>
        </div>
        <div className="mt-12 w-full text-sm font-medium text-center text-gray-500 dark:text-gray-300">
          <div className="flex justify-center mb-4 text-center">
            <button
              type="button"
              className="py-3 w-full text-lg text-indigo-700 bg-indigo-100 hover:bg-indigo-200 rounded-md border border-transparent focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              onClick={async () => {
                if (step === 0 || step === 1) {
                  //@ts-expect-error
                  swiper?.slideTo(step + 1);
                } else {
                  if (window.ethereum) {
                    try {
                      const accounts = await window?.ethereum.request({
                        method: "eth_requestAccounts",
                      });
                      if (accounts && accounts.length > 0) {
                        if (isEnabled) {
                          //@ts-expect-error
                          swiper?.slideTo(0);
                          setIsEnabled(false);
                          window.location.reload();
                        } else {
                          setIsEnabled(true);
                          toast.success("Success!");
                        }
                      }
                    } catch (error) {
                      console.error(error);
                      toast.error(`Error: ${error}`);
                    }
                  }
                }
              }}
            >
              {step === 0 && "I've enabled the extension"}
              {step === 1 && "I've allowed website permissions"}
              {step === 2 && isEnabled && "Success! Take me back"}
              {step === 2 && !isEnabled && "Testing wallet connection"}
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
      <Toaster />
    </Page>
  );
}
