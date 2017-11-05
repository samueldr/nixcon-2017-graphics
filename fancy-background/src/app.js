import React from "react";
import FancyLayer from "./fancy_layer";

const Bumper = () =>
		<div className="bumper">
			<img
				alt="logo"
				src="/nixcon-with-slashes.svg"
			/>
		</div>
	;

const App = () =>
	<div>
		<FancyLayer />
	</div>;

export default App;
