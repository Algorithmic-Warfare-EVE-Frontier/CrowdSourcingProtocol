import { useForm, SubmitHandler } from "react-hook-form";
import { useMUD } from "../../../MUDContext";
import { Hex } from "viem";

interface Props {
  vectorId: Hex;
}

interface IPotentialForm {
  strength: bigint;
}

export type PotentialParams = IPotentialForm & Props;

export default function PotentialForm({ vectorId }: Props) {
  const { register, handleSubmit } = useForm<IPotentialForm>();
  const {
    systemCalls: { createDelta },
  } = useMUD();

  const onSubmit: SubmitHandler<IPotentialForm> = async (data) => {
    await createDelta({
      vectorId,
      ...data,
    });
  };

  return (
    <div className="Quantum-Container font-semibold">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className=" grid grid-cols-2 gap-4">
          <label className=" ">Strength</label>
          <input
            {...register("strength")}
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
