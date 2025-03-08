import styled from "styled-components";
import { useRef, useState, useEffect } from "react";
const DEADZONE = 0.1;
let boundary = 350;
function Joystick({ sendInput }) {
	const canvasRef = useRef(null);
	const touchesRef = useRef([]);

	const stick0_location = useRef(null);
	const stick1_location = useRef(null);
	const leftTouchIDs = useRef([]);
	const rightTouchIDs = useRef([]);
	boundary = canvasRef.current ? canvasRef.current.clientHeight / 2 : 350;

	const processInput = (touches) => {
		let input0 = false;
		let input1 = false;
		for (let i = 0; i < touches.length; i++) {
			const touch = touches[i];
			const isLeftTouch = leftTouchIDs.current.some(id => id === touch.identifier);
			

			if (stick0_location.current !== null) {
				const x = stick0_location.current.x;
				const y = stick0_location.current.y;
				if (isLeftTouch && checkDeadzone(touch.pageX, touch.pageY, x, y, 120)) {
					updateInput(0, getDirection(touch.pageX, touch.pageY, x, y));
					input0 = true;
				}
			}
			if (stick1_location.current !== null) {
				const x = stick1_location.current.x;
				const y = stick1_location.current.y;
				if (!isLeftTouch && checkDeadzone(touch.pageX, touch.pageY, x, y, 120)) {
					updateInput(1, getDirection(touch.pageX, touch.pageY, x, y));
					input1 = true;
				}
			}
		}
		if (!input0) {
			updateInput(0, null);
		}
		if (!input1) {
			updateInput(1, null);
		}
	};
	const updateInput = (joystick, direction) => {
		sendInput({ joystick: joystick, direction: direction });
	};
	useEffect(() => {
		const canvas = canvasRef.current;
		const ctx = canvas.getContext("2d");

		const width = canvas.clientWidth;
		const height = canvas.clientHeight;
		canvas.width = width;
		canvas.height = height;

		function render() {
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			ctx.strokeStyle = "black";
			ctx.lineWidth = 5;
			ctx.setLineDash([5, 15]);
			ctx.beginPath();
			ctx.moveTo(0, boundary);
			ctx.lineTo(400, boundary);

			ctx.stroke();
			ctx.setLineDash([]);
			ctx.lineWidth = 1;
			if (stick0_location.current !== null) {
				const x = stick0_location.current.x;
				const y = stick0_location.current.y;
				drawJoyStick(ctx, x, y, 120);
				drawJoyStick(ctx, x, y, 120 * DEADZONE);
			}
			if (stick1_location.current !== null) {
				const x = stick1_location.current.x;
				const y = stick1_location.current.y;
				drawJoyStick(ctx, x, y, 120);
				drawJoyStick(ctx, x, y, 120 * DEADZONE);
			}

			const touches = touchesRef.current;

			for (let i = 0; i < touches.length; i++) {
				const touch = touches[i];
				ctx.fillStyle = "black";
				ctx.beginPath();
				ctx.arc(touch.pageX, touch.pageY - 30, 20, 0, 2 * Math.PI, true);
				ctx.fill();
				ctx.stroke();
			}
			requestAnimationFrame(render);
		}
		requestAnimationFrame(render);

		const handleTouchStart = (event) => {
			event.preventDefault();
			// get the most recent touch
			const touch = event.touches[event.touches.length - 1];
			if (touch.pageY < boundary) {
				leftTouchIDs.current.push(touch.identifier);
				if (stick0_location.current === null) {
					stick0_location.current = { x: touch.pageX, y: touch.pageY };
				}
			}
			if (touch.pageY > boundary) {
				rightTouchIDs.current.push(touch.identifier);
				if (stick1_location.current === null) {
					stick1_location.current = { x: touch.pageX, y: touch.pageY };
				}
			}
			processInput(event.touches);
			touchesRef.current = event.touches;
		};

		const handleTouchMove = (event) => {
			event.preventDefault();
			// ctx.clearRect(0, 0, canvas.width, canvas.height); // Clear the canvas before drawing

			// const rect = canvas.getBoundingClientRect();

			processInput(event.touches);
			touchesRef.current = event.touches;
		};
		const handleTouchEnd = (event) => {
			const endedTouches = Array.from(event.changedTouches);
			endedTouches.forEach((touch) => {
				leftTouchIDs.current = leftTouchIDs.current.filter(
					(id) => id !== touch.identifier
				);
			});
			if (leftTouchIDs.current.length === 0) {
				stick0_location.current = null;
			}
			endedTouches.forEach((touch) => {
				rightTouchIDs.current = rightTouchIDs.current.filter(
					(id) => id !== touch.identifier
				);
			});
			if (rightTouchIDs.current.length === 0) {
				stick1_location.current = null;
			}
			processInput(event.touches);
			touchesRef.current = event.touches;
		};

		canvas.addEventListener("touchstart", handleTouchStart, false);
		canvas.addEventListener("touchmove", handleTouchMove, false);
		canvas.addEventListener("touchend", handleTouchEnd, false);

		return () => {
			canvas.removeEventListener("touchmove", handleTouchMove);
		};
	}, [canvasRef]);
	return (
		<MainConainer>
			<Canvas id="canvas" ref={canvasRef} ></Canvas>
		</MainConainer>
	);
}

const drawJoyStick = (ctx, x, y, r) => {
	ctx.fillStyle = "#adcfff";
	ctx.beginPath();
	ctx.arc(x, y, r, 0, 2 * Math.PI);
	ctx.fill();
	ctx.stroke();
};
const checkDeadzone = (x, y, cx, cy, r) => {
	const dist = Math.sqrt((x - cx) ** 2 + (y - cy) ** 2);
	return dist > r * DEADZONE;
};
const getDirection = (x, y, cx, cy) => {
	const angle = Math.atan2(y - cy, x - cx) + -Math.PI / 2; //add pi/4 because we are rotating the screen for gameplay
	const roundedAngle = Math.round(angle / (Math.PI / 4)) * (Math.PI / 4);
	console.log(angle);
	return angle;
};

export default Joystick;

const MainConainer = styled.div`
	display: flex;
	flex-direction: column;
	height: 100svh;
	width: 100vw;
	justify-content: center;
	align-items: center;
`;
const Canvas = styled.canvas`
	height: 100%;
	width: 100%;
	background-color: red;
	touch-action: none;
	border: 5px solid blue;
`;
