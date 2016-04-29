import { Socket } from "phoenix"

let socket = new Socket("/ws", {
  params: { token: window.userToken }
})

socket.connect();

export default socket
