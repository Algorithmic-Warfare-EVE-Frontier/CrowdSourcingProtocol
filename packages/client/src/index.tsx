import ReactDOM from "react-dom/client";
import { RouterProvider } from "react-router-dom";
import { ThemeProvider } from "@mui/material";
import { setup } from "./mud/setup";
import { MUDProvider } from "./MUDContext";
import {
  SmartObjectProvider,
  FeedbackProvider,
  WalletProvider,
  WorldProvider,
} from "@eveworld/contexts";
import { darkTheme } from "./theme";
import { router } from "./router";

const rootElement = document.getElementById("root");
if (!rootElement) throw new Error("React root not found");
const root = ReactDOM.createRoot(rootElement);

// TODO: figure out if we actually want this to be async or if we should render something else in the meantime
setup().then(async (setup) => {
  root.render(
    <WalletProvider>
      <WorldProvider>
        <ThemeProvider theme={darkTheme}>
          <SmartObjectProvider>
            <FeedbackProvider>
              <MUDProvider value={setup}>
                <RouterProvider router={router} />
              </MUDProvider>
            </FeedbackProvider>
          </SmartObjectProvider>
        </ThemeProvider>
      </WorldProvider>
    </WalletProvider>
  );
});
