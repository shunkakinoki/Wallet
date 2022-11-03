const colors = [
  "red",
  "orange",
  "yellow",
  "green",
  "teal",
  "blue",
  "indigo",
  "pink",
  "purple",
];

const fills: {
  readonly [key in typeof colors[number]]: string;
} = {
  red: "FF3B30",
  orange: "FF9500",
  yellow: "FFCC00",
  green: "34C759",
  teal: "5AC8FA",
  blue: "007AFF",
  indigo: "5856D6",
  purple: "AF52DE",
  pink: "FF2D55",
};

export const Avatar = ({ color }: { color: string }) => {
  const fillColor = fills[color];

  return (
    <svg
      width="40"
      height="40"
      viewBox="0 0 49 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <rect
        x="0.666626"
        width="48"
        height="48"
        rx="24"
        fill={`#${fillColor}`}
      />
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M24.6666 39C32.9509 39 39.6666 32.2843 39.6666 24C39.6666 15.7157 32.9509 9 24.6666 9C16.3824 9 9.66663 15.7157 9.66663 24C9.66663 32.2843 16.3824 39 24.6666 39ZM21.924 14.3988C22.0495 14.0981 21.981 13.7515 21.7506 13.5211C21.5203 13.2907 21.1736 13.2222 20.873 13.3477C16.8102 15.043 13.9524 19.0539 13.9524 23.7342C13.9524 29.9474 18.9892 34.9842 25.2024 34.9842C29.8827 34.9842 33.8936 32.1264 35.5889 28.0636C35.7144 27.763 35.6459 27.4163 35.4155 27.186C35.1852 26.9556 34.8385 26.8871 34.5378 27.0126C33.3967 27.4887 32.1438 27.7521 30.8274 27.7521C25.5018 27.7521 21.1845 23.4348 21.1845 18.1092C21.1845 16.7928 21.4479 15.5399 21.924 14.3988Z"
        fill="white"
      />
    </svg>
  );
};
