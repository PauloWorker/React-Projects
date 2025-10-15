import Footer from './footer.jsx';
import Header from './header.jsx';
import ListGroup from './components/listGroup.js';
import Comp from './Comp.jsx';
import Alert from './components/Alert.js';

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
      {/* <Header/>
      <Footer/>
      <ListGroup items={items} heading="Cities" onSelectItem={handleSelectedItem} /> */}

      <div>
        <Alert />
      </div>

    </>
  );
}

export default App;