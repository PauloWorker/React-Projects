import { useState } from "react";

function ListGroup() {

    const [lists, setLists] = useState([""]);  // <-- state array
    const [name, setName] = useState("");

    const add_button = (event: any) => {
        setName(event.target.value);
    }

    const confirmName = (event: any) => {
        event.preventDefault();

        // Add item SAFELY (don't mutate state)
        setLists([...lists, name.trim()]);
        
        // clear input
        setName("");
    }

    const list = lists.map((item, index) => {
        return item.length > 0 && (
            <div key={index} className="list border border-primary rounded-1 m-1">
                {item}
                <div className="options">
                    <button className="btn btn-outline-success btn-sm">finish</button>
                    <button className="btn btn-outline-warning btn-sm">edit</button>
                    <button className="btn btn-outline-danger btn-sm">delete</button>
                </div>
            </div>
        );
    });

    return (
        <>
            {/* Title */}
            <div>
                <h1>To do List</h1>
            </div>

            {/* Type bar */}
            <div className="input-group mb-3">
                <form onSubmit={confirmName} className="input-group">
                    <input
                        className="form-control border"
                        type="text"
                        value={name}
                        onChange={add_button}
                        placeholder="Type here what you want to add"
                    />
                    <button className="input-group-text btn btn-success col-sm-1">
                        Add
                    </button>
                </form>
            </div>

            {/* Lists here */}
            <div className="lists-window">
                <div className="row">
                    {list}
                </div>
            </div>
        </>
    );
}

export default ListGroup;
