import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import CSPView from "./components/CSPView";
import VectorForm from "./components/csp/forms/VectorForm";

export const router = createBrowserRouter([
  {
    element: <App />,
    children: [
      {
        path: "*",
        element: <CSPView />,
      },
      {
        path: "new-vector",
        element: <VectorForm />,
      },
    ],
  },
]);
