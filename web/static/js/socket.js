import { Socket } from "phoenix"

let socket = new Socket("/socket", {});
socket.connect()

export default socket
