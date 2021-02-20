import "../css/app.css"
import "phoenix_html"

import React, { useState, useEffect } from 'react';
import { ch_join, ch_push, ch_reset, ch_display } from './socket'
import ReactDOM from 'react-dom';


function App() {

    // set state with attempts, guess, guesses, results, and error fields
    const [state, setState] = useState({
        //which guess number user is on out of 8
        tries: 0,
        //current guess made
        guess: "",
        //previous guesses made
        guesses: [],
        //cows and bulls results from previous guesses made
        results: [],
        //in the case of an error
        error: ""
    });

    //update the state
    useEffect(() => {
        ch_join(setState);
    })

    //update guess in state
    function updateGuess() {
        ch_push(state.guess)
    }

    //update guesses made in state
    function addGuess(ev) {
        ch_display(ev.target.value);
    }

    //update guess when enter key is pressed
    function keyPressed(ev) {
        if (ev.key == 'Enter') {
            updateGuess();
        }
    }

    //update printed rows of guesses made and results from those guesses
    let rows = [];
    for (let i = 0; i < 8; i++) {
        rows.push(
        <tr key={i}>
            <td key={i}>{state.guesses[i]}</td>
            <td key={i}>{state.results[i]}</td>
        </tr>
        )
    }

    //update printed table with headers
    function UpdateTable() {
        return (
            <table>
                <thead>
                    <tr>
                        <th><center>Guesses Made:</center></th>
                        <th><center>Cows and Bulls:</center></th>
                    </tr>
                </thead>
                <tbody>
                    {rows}
                </tbody>
            </table>
        )
    }

    //restart the game
    function restart() {
        ch_reset();
    }

    return (
        <div className="Bulls">
            <center>
                <h1>Bulls and Cows</h1>
                <div>Instructions:</div>
                <div>Discover the hidden code.</div>
                <div>Make a 4 digit guess in each box. Each digit must be unique.</div>
                <div>Bulls = correct code, correct position.</div>
                <div>Cows = correct code, wrong position.</div>
                <div>Once a guess has been made, it will be evaluated in the results column.</div>
                <div>You can make 8 attempts total.</div>
                <h2>{state.error}</h2>
                <div>
                    <div>
                        <span><input value={state.guess} type="text" onChange={addGuess} onKeyPress={keyPressed} /></span>
                        <span><button onClick={updateGuess}>Guess</button></span>
                        <div><button onClick={restart}>Restart</button></div>
                    </div>
                        <UpdateTable></UpdateTable>
                </div>
            </center>
        </div>
    );
}

ReactDOM.render(
    <React.StrictMode>
        <App />
    </React.StrictMode>,
    document.getElementById('root')
);