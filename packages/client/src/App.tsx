import { Outlet } from "react-router-dom";
import { useContext, useEffect, useState } from "react";

import "./App.css";

import { FeedbackContext, WalletContext } from "@eveworld/contexts";
import {
  Alert,
  EveConnectWallet,
  EveFeralCodeGen,
  EveScroll,
  Header,
} from "@eveworld/ui-components";

const App = () => {
  const {
    connected, // whether you are connected or not
    publicClient, //  ?? what is this
  } = useContext(WalletContext);
  const { notification } = useContext(FeedbackContext);

  if (!connected || !publicClient) {
    return (
      <>
        <div className="h-full w-full bg-crude-5 -z-10">
          {/* This takes care of all the wallet aspects */}
          <EveConnectWallet />

          <GenerateEveFeralCodeGen style="top-12" />
          <GenerateEveFeralCodeGen style="bottom-12" />
        </div>
      </>
    );
  }

  return (
    <div>
      <Alert
        message={notification.message}
        txHash={notification.txHash}
        severity={notification.severity}
        handleClose={notification.handleClose}
        isOpen={notification.isOpen}
        isStyled={false}
      />

      <div className="bg-crude-5 -z-10 w-screen min-h-screen">
        <div className="flex flex-col align-center max-w-[560px] mobile:max-w-[377px] mx-auto mb-6 h-screen">
          <Header />
          <Outlet />
        </div>
      </div>
      <GenerateEveFeralCodeGen style="bottom-12 text-xs -z-10" />
    </div>
  );
};

export default App;

// This component is just for the looks. It displays some weird combinations of letters.
const GenerateEveFeralCodeGen = ({
  style,
  count = 5,
}: {
  style?: string;
  count?: number;
}) => {
  const codes = Array.from({ length: count }, (_, i) => i);
  return (
    <div
      className={`absolute flex justify-between px-10 justify-items-center w-full text-xs ${style}`}
    >
      {codes.map((index) => (
        <EveFeralCodeGen key={index} />
      ))}{" "}
    </div>
  );
};
