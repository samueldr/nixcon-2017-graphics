import React, {Component} from "react";
import ReactTimeout from "react-timeout"
import times from "lodash/times";

const COLS = 8 * 2;
const ROWS = 10;

class FancyLayer extends Component {
	constructor() {
		super();
		this.state = {
			highlighted: -1,
		};
	}

	highlight() {
		const highlighted = Math.round(Math.random() * COLS * ROWS);
		this.setState({highlighted});
	}

	componentDidMount() {
		this.props.setInterval(() => this.highlight(), 100);
	}

	render() {
		return (
			<div className="fancy-layer">
				{
					times(COLS, (i) =>
						<div key={i} className={`fancy-layer--column is-${i%2?"odd":"even"}`}>
							{
								times(ROWS, (j) =>
									<div
										key={j}
										className={[
											"fancy-layer--hex",
											`is-item-${i*ROWS + j}` ,
											i*ROWS+j === this.state.highlighted ? "is-highlighted" : "is-not-highlighted",
										].join(" ")}
									/>
								)
							}
						</div>
					)
				}
			</div>
		);
	}
}

export default ReactTimeout(FancyLayer);
