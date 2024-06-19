import _ from "lodash";

type Props = {
  title: string;
  labelStyle: string;
  containerStyle: string;
};

export default function FormInput({
  title,
  labelStyle,
  containerStyle,
}: Props) {
  return (
    <>
      <div className={containerStyle}>
        <label className={labelStyle}>{_.capitalize(title)}</label>
        <input className="border border-brightquantum bg-crude" />
      </div>
    </>
  );
}
