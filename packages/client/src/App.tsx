import { Outlet } from "react-router-dom";
import { useContext } from "react";

import "./App.css";

import { FeedbackContext, WalletContext } from "@eveworld/contexts";
import { Alert, EveConnectWallet } from "@eveworld/ui-components";
import EveFeralCodeGenerator from "./components/creative/FeralCodeGen";

export default function App() {
  const { connected, publicClient } = useContext(WalletContext);
  const { notification } = useContext(FeedbackContext);

  // Prompts the wallet connect screen.
  if (!connected || !publicClient) {
    return (
      <>
        <div className="h-full w-full bg-crude-5 -z-10">
          <EveConnectWallet />

          <EveFeralCodeGenerator style="top-12" />
          <EveFeralCodeGenerator style="bottom-12" />
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

      <div className="bg-crude-5 -z-10 w-screen min-h-screen ">
        <div className="max-w-[560px] mx-auto relative flex flex-col items-center justify-center">
          <Outlet />
        </div>
      </div>
      <EveFeralCodeGenerator style="bottom-12 text-xs -z-10" />
    </div>
  );
}
