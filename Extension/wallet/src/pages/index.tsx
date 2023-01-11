import clsx from "clsx";
import { Page } from "konsta/react";
import { useEffect, useMemo, useState } from "react";
import ReactConfetti from "react-confetti";
import toast, { Toaster } from "react-hot-toast";
import { Swiper, SwiperSlide } from "swiper/react";

import { CarouselButton } from "../components/CarouselButton";
import { useIsInitial } from "../hooks/useIsInitial";
import { useUserStep } from "../hooks/useUserStep";

export default function Home() {
  const [isSafari, setIsSafari] = useState(false);
  const [isMounted, setIsMounted] = useState(false);
  const [isEnabled, setIsEnabled] = useState(false);

  const [sstep, setStep] = useUserStep(state => {
    return [state.step, state.setStep];
  });

  const [isInitial, setIsInitial] = useIsInitial(state => {
    return [state.isInitial, state.setIsInitial];
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

  const mountedIsInitial = useMemo(() => {
    if (isMounted) {
      return isInitial;
    }
    return false;
  }, [isMounted, isInitial]);

  useEffect(() => {
    if (step === 2 && mountedIsInitial) {
      setIsInitial(false);
      window.location.reload();
    }
  }, [mountedIsInitial, setIsInitial, step]);

  return (
    <Page>
      <title>Light Wallet</title>
      <div className="container mx-auto flex max-w-md flex-col justify-between px-3 lg:h-4/6">
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
            <span className="inline-flex items-center rounded-md bg-indigo-100 py-0.5 px-2.5 text-sm font-medium text-indigo-800">
              <svg
                className="mr-1.5 -ml-0.5 h-2 w-2 text-indigo-600"
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
          <div className="relative block w-full">
            <Swiper
              initialSlide={sstep}
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
                  playsInline
                  autoPlay
                  muted
                  loop
                  src={`/step_1.mov`}
                  className="pointer-events-none rounded-md"
                />
              </SwiperSlide>
              <SwiperSlide key={1}>
                {/* eslint-disable-next-line jsx-a11y/media-has-caption */}
                <video
                  playsInline
                  autoPlay
                  muted
                  loop
                  src={`/step_2.mov`}
                  className="pointer-events-none rounded-md"
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
        <div className="w-full text-center text-sm font-medium text-gray-500 dark:text-gray-300">
          <div className="mb-4 flex justify-center text-center">
            <button
              type="button"
              className="w-full rounded-md border border-transparent bg-indigo-100 py-3 text-lg text-indigo-700 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
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
                          setIsInitial(true);
                          window.location.reload();
                        } else {
                          setIsEnabled(true);
                          toast.success("Success!");
                        }
                      }
                    } catch (error) {
                      console.error(error);
                      toast.error(`Error: ${error}! Try refreshing the page.`);
                    }
                  } else {
                    toast.error(`Wallet not found! Try refreshing the page.`);
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
