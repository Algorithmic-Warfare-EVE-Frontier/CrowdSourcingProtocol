import { useForm, SubmitHandler } from "react-hook-form";
import { useMUD } from "../../../MUDContext";

export interface IVectorForm {
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
    console.log(data);
    await initiateVector(data);
  };

  return (
    <div className="Quantum-Container font-semibold">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="grid grid-cols-2 gap-4">
          <label>Capacity</label>
          <input {...register("capacity")} className="" />
          <label>Lifetime</label>
          <input {...register("lifetime")} className="" />
          <label>Insight</label>
          <textarea {...register("insight")} className="" />
        </div>
        <button className="primary primary-sm">
          <input type="submit" />
        </button>
      </form>
    </div>
  );
}
