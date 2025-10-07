import { MouseEvent } from "react";
import { useState } from "react";

function ListGroup() {

    let items = [
        'New york',
        'São Paulo',
        'Dakota',
        'London',
        'Roma',
        'Veneza'
    ];
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
            <ul className="list-group">
                {message()}
                {items.map((item, index) => ( 
                    <li onClick={() => handleClick(index)} key={item} className={selectedIndex === index ? 'list-group-item active' : 'list-group-item'}>{item}</li>
                ))}
            </ul>
        </>
    );
}

export default ListGroup;