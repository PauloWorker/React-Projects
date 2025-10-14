import Footer from './footer.jsx';
import Header from './header.jsx';
import ListGroup from './components/listGroup.js';
import Comp from './Comp.jsx';

function App() {
    let items = [
        'New york',
        'São Paulo',
        'Dakota',
        'London',
        'Roma',
        'Veneza'
    ];

    const handleSelectedItem = (item: string) => {
      console.log(item);
    }
  
  return (
    <>
      <Header/>
      <Footer/>
      <ListGroup items={items} heading="Cities" onSelectItem={handleSelectedItem} />

    </>
  );
}

export default App;