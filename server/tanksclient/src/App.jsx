import { useState, useEffect } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import Joystick from "./views/Joystick";


const socket = new WebSocket(import.meta.env.VITE_SERVER_URL); //chanage this all the time

function App() {
	function handleMessage(event) {
		console.log("Message from server ", event.data);
		
		
	}
	useEffect(() => {
		
		socket.addEventListener("message", handleMessage);
		console.log("Adding event listener");

		return () => socket.removeEventListener("message", handleMessage);
	}, []);
	return (
		<div>
			{/* <div className="card">
				<button
					onClick={() => {
						socket.send("Hello from vite!");
						console.log("Sent message");
					}}
				>
					Send message
				</button>

			</div> */}
      <Joystick sendInput={(data)=>{
        socket.send(JSON.stringify(data));
      }}
	  />
	  
		</div>
	);
}

export default App;

//npm run dev -- --host