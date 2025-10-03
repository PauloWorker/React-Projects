function Header() {
    const name = "My React App";

    return(
        <header>
            <h1>Welcome to {name}</h1>
            <nav>
            <ul>
                <li><a href="#">Home</a></li>
                <li><a href="#">About</a></li>
                <li><a href="#">Services</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
            </nav>
            <hr />
            
        </header>
    );
}

export default Header;