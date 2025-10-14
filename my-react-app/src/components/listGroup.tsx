import { MouseEvent } from "react";
import { useState } from "react";

// { items: [], heading: string}
interface ListGroupProps {
    items: string[];
    heading: string;

    onSelectItem: (item: string) => void;
}

function ListGroup({ items, heading, onSelectItem }: ListGroupProps) {



    // items = [];
    const [selectedIndex, setSelectedIndex] = useState(-1);

    const message = () => {
        return items.length === 0 && <p>No items found</p>;
    }

    const handleClick = (index: number) => {
        console.log(index);
        setSelectedIndex(index);
        
    }   

    return (
        <>
            <h1>{heading}</h1>
            <ul className="list-group">
                {message()}
                {items.map((item, index) => ( 
                    <li onClick={() => {handleClick(index); onSelectItem(item)}} key={item} className={selectedIndex === index ? 'list-group-item active' : 'list-group-item'}>{item}</li>
                ))}
            </ul>
        </>
    );
}

export default ListGroup;