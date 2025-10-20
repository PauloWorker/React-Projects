function ListGroup(){
    return(
        <>
            {/* Title */}
            <div>
                <h1>To do List</h1>
            </div>

            {/* Type bar */}
            <div className="input-group mb-3">
                <input type="text" name="type-bar" id="type-bar" placeholder="Type here what do you want to add" />
                <span className="input-group-text" id="">Add</span>
            </div>
        </>
    );
}

export default ListGroup;