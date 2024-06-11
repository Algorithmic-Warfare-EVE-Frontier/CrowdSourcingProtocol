import { useForm, SubmitHandler } from "react-hook-form";
import { useMUD } from "../../MUDContext";

export interface IVectorFormInput {
  symbol: string;
  codename: string;
  threshold: bigint;
  target: bigint;
  deadline: number;
  title: string;
  description: string;
}

export function VectorForm() {
  const {
    systemCalls: { createVector },
  } = useMUD();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<IVectorFormInput>();

  const onSubmit: SubmitHandler<IVectorFormInput> = async (data) =>
    await createVector(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <label>Symbol</label>
      <input {...register("symbol", { required: true })} />
      {errors.symbol && <p>Symbol is required.</p>}
      <br />
      <label>Codename</label>
      <input {...register("codename", { required: true })} />
      {errors.codename && <p>Codename is required.</p>}

      <br />
      <label>Threshold</label>
      <input {...register("threshold", { required: true })} />
      {errors.threshold && <p>Threshold is required.</p>}

      <br />
      <label>Target</label>
      <input {...register("target", { required: true })} />
      {errors.target && <p>Target is required.</p>}

      <br />
      <label>Deadline</label>
      <input {...register("deadline", { required: true })} />
      {errors.deadline && <p>Deadline is required.</p>}

      <br />
      <label>Title</label>
      <input {...register("title", { required: true })} />
      {errors.title && <p>Title is required.</p>}

      <br />
      <label>Description</label>
      <input {...register("description", { required: true })} />
      {errors.description && <p>Description is required.</p>}

      <input type="submit" />
    </form>
  );
}
