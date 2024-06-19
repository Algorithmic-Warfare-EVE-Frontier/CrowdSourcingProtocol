import { useForm, SubmitHandler } from "react-hook-form";
import { useMUD } from "../../../MUDContext";
import { Hex } from "viem";

interface Props {
  motionId: Hex;
}

interface IForceForm {
  direction: number;
  insight: string;
}

export type ForceParams = IForceForm & Props;

export default function PotentialForm({ motionId }: Props) {
  const { register, handleSubmit } = useForm<IForceForm>();
  const {
    systemCalls: { applyForce },
  } = useMUD();

  const onSubmit: SubmitHandler<IForceForm> = async (data) => {
    await applyForce({
      motionId,
      ...data,
    });
  };

  return (
    <div className="Quantum-Container font-semibold">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className=" grid grid-cols-2 gap-4">
          <label className=" ">Direction</label>
          <select
            {...register("direction")}
            className="border border-brightquantum bg-crude"
          >
            <option value="0">Along</option>
            <option value="1">Against</option>
          </select>
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
