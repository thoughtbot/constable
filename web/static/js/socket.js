import { Socket } from "phoenix"

let socket = new Socket("/ws", {
  params: { token: window.userToken },
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) }
})

socket.connect();

export default socket
