function Food() {

    const food1 = "Pizza";
    const food2 = "X-Burger";

    return (
        <div>
            <h1>My Favorite Foods</h1>
            <ul>
                <li>{food1}</li>
                <li>{food2}</li>
            </ul>
        </div>
    );
}

export default Food;