// eslint-disable-next-line import/no-named-as-default
import clsx from "clsx";
import type { FC } from "react";
import { useSwiper } from "swiper/react";

export const CarouselButton: FC<{ index: number }> = ({
  index,
}: {
  index: number;
}) => {
  const swiper = useSwiper();

  return (
    <div className="my-8 flex items-center justify-center space-x-2">
      <button
        className={clsx(
          "h-2.5 w-2.5 rounded-full bg-gray-400",
          index === 0 && "bg-indigo-300",
          index === 1 && "bg-gray-400",
        )}
        onClick={() => {
          return swiper.slideTo(0);
        }}
      />
      <button
        className={clsx(
          "h-2.5 w-2.5 rounded-full bg-gray-400",
          index === 1 && "bg-indigo-300",
          index === 2 && "bg-gray-400",
        )}
        onClick={() => {
          return swiper.slideTo(1);
        }}
      />
      <button
        className={clsx(
          "h-2.5 w-2.5 rounded-full bg-gray-400",
          index === 2 && "bg-indigo-300",
          index === 3 && "bg-gray-400",
        )}
        onClick={() => {
          return swiper.slideTo(2);
        }}
      />
    </div>
  );
};
