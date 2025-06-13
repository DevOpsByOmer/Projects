import { useEffect, useState } from 'react';
import './App.css';

function App() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetch(`${process.env.REACT_APP_API_URL}/message`)  // ⬅️ Use ENV variable with path
      .then((res) => res.json())
      .then((data) => setMessage(data.message))
      .catch((err) => console.error(err));
  }, []);

  return (
    <div className="App">
      <h1>🌐 Full Stack App</h1>
      <p>🚀 Backend says: <strong>{message}</strong></p>
    </div>
  );
}

export default App;
