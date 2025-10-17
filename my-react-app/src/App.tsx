import Footer from './footer.jsx';
import Header from './header.jsx';
import ListGroup from './components/listGroup.js';
import Comp from './Comp.jsx';
import Alert from './components/Alert.js';
import Button from './components/Buttons.tsx';
import { useState } from "react";

function App() {
    let items = [
        'New york',
        'São Paulo',
        'Dakota',
        'London',
        'Roma',
        'Veneza'
    ];

    const [alertVisible, setAlertVisibility] = useState(false);

    
    const handleSelectedItem = (item: string) => {
      console.log(item);
    }

    const activeAlert = (state: boolean) => {
      setAlertVisibility(state);
      console.log(state);
    }

    const showAlert = () => {
      return alertVisible && <Alert action={() => activeAlert(false)} >Alarted</Alert>;
    }
  
  return (
    <>
      {/* <Header/>
      <Footer/>
      <ListGroup items={items} heading="Cities" onSelectItem={handleSelectedItem} /> */}
      {showAlert()}

      <div>
        <Button color='primary' onClick={() => activeAlert(true) }>
          Primary1
        </Button>
      </div>

    </>
  );
}

export default App;