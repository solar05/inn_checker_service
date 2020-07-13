// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
document.addEventListener("DOMContentLoaded", function(event) {
  const channel = socket.channel("inn:checks", {});
  const innInput = document.querySelector("#chat-input");
  const innContainer = document.querySelector("#inns");
  const errorTag = document.getElementById("error-tag");
  const innRegexp = /^[0-9]+$/;

  innInput.addEventListener("keypress", event => {
    if (event.key === 'Enter'){
      if (isInnValid(innInput.value)) {
        showInputError(false);
        channel.push("new_inn", {body: innInput.value, client: window.client})
        innInput.value = ""
      } else {
        showInputError(true);
      }
    }
  })

  const sendData = () => {
    if (isInnValid(innInput.value)) {
      showInputError(false);
      channel.push("new_inn", {body: innInput.value, client: window.client})
      innInput.value = ""
    } else {
        showInputError(true);
    }
  }

  window.sendData = sendData;


  channel.on("inn_added", payload => {
    const innItem = document.createElement("td");
    const stateItem = document.createElement("td");
    stateItem.innerText = "отправлен";
    stateItem.setAttribute("class", "text-primary");
    const trElem = document.createElement("tr");
    trElem.setAttribute("class", "col-md-10 m-2 h4");
    trElem.setAttribute("id", payload.id);
    stateItem.setAttribute("id", `state-${payload.id}`);
    innItem.innerText = `[${payload.date}] ${payload.body}`;
    trElem.prepend(innItem);
    trElem.appendChild(stateItem);
    innContainer.prepend(trElem);
  })
  
  
  channel.on("inn_error", payload => {
    const innItem = document.createElement("td");
    const stateItem = document.createElement("td");
    stateItem.innerText = "некорректен";
    stateItem.setAttribute("class", "text-primary");
    const trElem = document.createElement("tr");
    trElem.setAttribute("class", "col-md-10 m-2 h4");
    trElem.setAttribute("id", payload.id);
    stateItem.setAttribute("id", `state-${payload.id}`);
    innItem.innerText = `[${payload.date}] ${payload.body}`;
    trElem.prepend(innItem);
    trElem.appendChild(stateItem);
    innContainer.prepend(trElem);
  })

  channel.on("inn_correct", payload => {
    const stateItem = document.getElementById(`state-${payload.id}`);
    stateItem.setAttribute("class", "text-success");
    stateItem.textContent = "корректен"
  })

  channel.on("inn_incorrect", payload => {
    const stateItem = document.getElementById(`state-${payload.id}`);
    stateItem.setAttribute("class", "text-danger");
    stateItem.textContent = "некорректен"
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  const isInnValid = (inn) => {
    const innLength = inn.length;
    return (innLength == 10 || innLength == 12) && innRegexp.test(inn);
  };

  const showInputError = (state) => {
      errorTag.hidden = !state;
  }

});

export default socket
