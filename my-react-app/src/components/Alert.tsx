import { ReactNode } from "react";
import Button from "./Buttons";

interface Props {
    children: ReactNode;
    action?: () => void;
}

const Alert = ({ children, action }: Props) => {

    return(
        <div className="alert alert-primary alert-content">{children} <Button color="danger" onClick={action}>x</Button></div>
    );
}

export default Alert;