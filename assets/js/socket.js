import { Socket } from "phoenix"
let socket = new Socket("/socket", { params: { token: "" } })
socket.connect()

let channel = socket.channel("game:1", {})



let state = {
  tries: 8,
  guess: "",
  guesses: [],
  results: [],
  error: ""
};

let callback = null;

//Functions state_update, ch_join, ch_push, ch_display, ch_reset taken from Professor Tuck's notes repo.

function state_update(st) {
  console.log("New state", st);
  state = st;
  if (callback) {
    callback(st);
  }
}

export function ch_join(cb) {
  callback = cb;
  callback(state);
}

export function ch_push(guess) {
  channel.push("guess", { guess: guess })
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to push", resp)
    })
}

export function ch_display(display = "temp") {
  channel.push("display", { display: display })
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to display", resp)
    });
}

export function ch_reset() {
  channel.push("reset", {})
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to reset", resp)
    });
}

channel.join()
  .receive("ok", state_update)
  .receive("error", resp => {
    console.log("Unable to join", resp)
  });

export default socket;