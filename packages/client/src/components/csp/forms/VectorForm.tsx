import { useForm, SubmitHandler } from "react-hook-form";
import { useMUD } from "../../../MUDContext";

export type VectorParams = IVectorForm;

interface IVectorForm {
  capacity: bigint;
  lifetime: bigint;
  insight: string;
}

export default function VectorForm() {
  const { register, handleSubmit } = useForm<IVectorForm>();
  const {
    systemCalls: { initiateVector },
  } = useMUD();

  const onSubmit: SubmitHandler<IVectorForm> = async (data) => {
    await initiateVector(data);
  };

  const inputStyle = "bg-crude border border-brightquantum";

  return (
    <div className="Quantum-Container Absolute-Center font-semibold">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="grid grid-cols-2 gap-4">
          <label>Capacity</label>
          <input {...register("capacity")} className={inputStyle} />
          <label>Lifetime</label>
          <input {...register("lifetime")} className={inputStyle} />
          <label>Insight</label>
          <textarea {...register("insight")} className={inputStyle} />
        </div>
        <button className="primary primary-sm">
          <input type="submit" />
        </button>
      </form>
    </div>
  );
}
