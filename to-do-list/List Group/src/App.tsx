import './App.css';
import Header from './components/Header';
import ListGroup from './components/ListGroup';

function App() {

  return (
    <>
      {/* Header Section */}
      <Header/>

      {/* Body */}
      <div className="container rounded">
        <div className="container-lg">
          <ListGroup/>
        </div>
      </div>
    </>
  )
}

export default App;
