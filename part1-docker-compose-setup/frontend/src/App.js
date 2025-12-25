import React, { useEffect, useState } from "react";

const API_URL = process.env.REACT_APP_API_URL;

function App() {
  const [health, setHealth] = useState("");
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetch("/healthcheck")
      .then(res => res.json())
      .then(data => setHealth(data.status));

    fetch("/message")
      .then(res => res.json())
      .then(data => setMessage(data.message));
  }, []);

  return (
    <div style={{ padding: "40px", fontFamily: "Arial" }}>
      <h1>Frontend Web App</h1>
      <p><strong>Healthcheck:</strong> {health}</p>
      <p><strong>Message:</strong> {message}</p>
    </div>
  );
}

export default App;

