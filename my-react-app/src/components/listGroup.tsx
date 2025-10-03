import { MouseEvent } from "react";

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
    let selectedIndex = -1;

    const message = () => {
        return items.length === 0 && <p>No items found</p>;
    }

    const handleClick = (event: MouseEvent) => {
        console.log(event);
    }

    return (
        <>
            <ul className="list-group">
                {message()}
                {items.map((item, index) => ( 
                    <li onClick={() => selectedIndex = index} key={item} className={selectedIndex === index ? 'list-group-item active' : 'list-group-item'}>{item}</li>
                ))}
            </ul>
        </>
    );
}

export default ListGroup;