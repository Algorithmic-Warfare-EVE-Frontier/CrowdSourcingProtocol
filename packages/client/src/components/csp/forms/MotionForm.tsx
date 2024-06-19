import { useForm, SubmitHandler } from "react-hook-form";
import { Hex } from "viem";
import { useMUD } from "../../../MUDContext";

interface Props {
  vectorId: Hex;
}

interface IMotionForm {
  momentum: bigint;
  lifetime: bigint;
  target: Hex;
  insight: string;
}

export type MotionParams = IMotionForm & Props;

export default function MotionForm({ vectorId }: Props) {
  const { register, handleSubmit } = useForm<IMotionForm>();
  const {
    systemCalls: { initiateMotion },
  } = useMUD();
  const onSubmit: SubmitHandler<IMotionForm> = (data) => {
    initiateMotion({
      vectorId,
      ...data,
    });
  };

  return (
    <div className="Quantum-Container font-semibold">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className=" grid grid-cols-2 gap-4">
          <label>Capacity</label>
          <input
            {...register("momentum")}
            className="border border-brightquantum bg-crude"
          />
          <label>Lifetime</label>
          <input
            {...register("lifetime")}
            className="border border-brightquantum bg-crude"
          />
          <label>Target</label>
          <input
            {...register("target")}
            className="border border-brightquantum bg-crude"
          />
          <label>Insight</label>
          <textarea
            {...register("insight")}
            className="border border-brightquantum bg-crude"
          />
        </div>
        <button className="primary primary-sm justify-center">
          <input type="submit" />
        </button>
      </form>
    </div>
  );
}
