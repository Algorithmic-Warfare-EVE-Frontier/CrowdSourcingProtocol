import { useForm, SubmitHandler } from "react-hook-form";
import { useMUD } from "../../../MUDContext";
import { Hex } from "viem";

export interface IPotentialForm {
  vectorId: Hex;
  strength: bigint;
}

export default function PotentialForm() {
  const { register, handleSubmit } = useForm<IPotentialForm>();
  const {
    systemCalls: { createDelta },
  } = useMUD();

  const onSubmit: SubmitHandler<IPotentialForm> = async (data) => {
    console.log(data);
    await createDelta(data);
  };

  return (
    <div className="Quantum-Container font-semibold">
      <form onSubmit={handleSubmit(onSubmit)}>
        <label className=" ">Vector ID</label>
        <input
          {...register("vectorId")}
          className="border border-brightquantum bg-crude"
        />
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
