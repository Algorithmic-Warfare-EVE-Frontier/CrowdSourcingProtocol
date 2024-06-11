import { useMUD } from "./MUDContext";
import { VectorForm } from "./components/forms/Vector";

export const App = () => {
  const {
    network: { tables, useStore },
  } = useMUD();

  const vectors = useStore((state) => {
    const records = Object.values(state.getRecords(tables.CSVectorsDataTable));
    return records;
  });

  return (
    <>
      <VectorForm />
      <table>
        <tbody>
          {vectors.map((vector) => (
            <tr key={vector.key.id}>
              <td>{vector.value.symbol}</td>
              <td>{vector.value.title}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
};
