function ListGroup(){
    return(
        <>
            {/* Title */}
            <div>
                <h1>To do List</h1>
            </div>

            {/* Type bar */}
            <div className="input-group mb-3">
                <input className="form-control" type="text" name="type-bar" id="type-bar" placeholder="Type here what you want to add" />
                <span className="input-group-text btn btn-success col-sm-1" id="add-button">Add</span>
            </div>

            {/* List here */}
            <div className="lists">
                
            </div>
        </>
    );
}

export default ListGroup;