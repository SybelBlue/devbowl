import consumer from "channels/consumer";

console.log("Room channel script loaded", Date.now());
console.log("Consumer:", consumer);

let reconnectAttempts = 0;
const maxReconnectAttempts = 5;
let roomChannel = null;

window.connect = function() {
  const roomElement = document.getElementById("room-top");

  if (!roomElement) {
    console.log("❌ No room element found");
    return false;
  }
  console.log("Room element found:", roomElement);
  const roomId = roomElement.dataset.roomId;
  console.log("Room ID:", roomId);

  function createRoomChannel() {
    console.log("Creating room channel...");

    if (roomChannel) {
      console.log("Unsubscribing existing channel");
      roomChannel.unsubscribe();
    }

    roomChannel = consumer.subscriptions.create(
      { channel: "RoomChannel", room_id: roomId },
      {
        connected() {
          console.log("✅ Connected to room channel!");
          reconnectAttempts = 0;

          // Show connection status
          const statusElement = document.getElementById("connection-status");
          if (statusElement) {
            statusElement.textContent = "Connected";
            statusElement.className = "connection-status connected";
          }

          // Check if there's already an active game when we connect
          setTimeout(() => {
            console.log("Checking for active game...");
            this.checkForActiveGame();
          }, 500);
        },

        disconnected() {
          console.log("❌ Disconnected from room channel");

          // Show disconnection status
          const statusElement = document.getElementById("connection-status");
          if (statusElement) {
            statusElement.textContent = "Disconnected";
            statusElement.className = "connection-status disconnected";
          }

          // Attempt to reconnect
          if (reconnectAttempts < maxReconnectAttempts) {
            reconnectAttempts++;
            console.log(
              `🔄 Attempting to reconnect (${reconnectAttempts}/${maxReconnectAttempts})...`
            );
            setTimeout(() => createRoomChannel(), 1000 * reconnectAttempts);
          } else {
            console.log("Max reconnect attempts reached");
          }
        },

        rejected() {
          console.log("🚫 Connection rejected");
          const statusElement = document.getElementById("connection-status");
          if (statusElement) {
            statusElement.textContent = "Connection rejected - try refreshing";
            statusElement.className = "connection-status rejected";
          }
        },

        received(data) {
          console.log("📨 Received data:", data);
          switch (data.type) {
            case "question_started":
              this.handleQuestionStarted(data);
              break;
            case "buzz_received":
              this.handleBuzzReceived(data);
              break;
            case "answer_submitted":
              this.handleAnswerSubmitted(data);
              break;
            case "user_joined":
              this.handleUserJoined(data);
              break;
          }
        },

        checkForActiveGame() {
          console.log("🔍 Checking for active game...");
          this.perform("get_current_state");
        },

        buzzIn() {
          console.log("🔥 Buzzing in...");
          if (consumer.connection.isOpen()) {
            this.perform("buzz_in", {});
          } else {
            console.log("Connection not open!");
            alert("Connection lost! Please refresh the page.");
          }
        },

        submitAnswer(buzzId, answer) {
          console.log("📝 Submitting answer:", answer);
          if (consumer.connection.isOpen()) {
            this.perform("submit_answer", {
              buzz_id: buzzId,
              answer: answer,
            });
          } else {
            console.log("Connection not open!");
            alert("Connection lost! Please refresh the page.");
          }
        },

        handleUserJoined(data) {
          console.log(`👋 ${data.user} joined the room`);
          const usersCount = document.getElementById("users-count");
          if (usersCount) {
            usersCount.textContent = `Users in room: ${data.users_count}`;
          }
        },

        handleQuestionStarted(data) {
          console.log("❓ Showing question:", data.question);
          const questionContent = document.getElementById("question-content");
          if (questionContent && data.question.toss_up) {
            questionContent.innerHTML = `
              <h3>${data.question.title}</h3>
              <p><strong>Toss-up:</strong> ${data.question.toss_up}</p>
              <p><em>Format: ${data.question.format}</em></p>
            `;
          }

          const buzzButton = document.getElementById("buzz-button");
          if (buzzButton) {
            buzzButton.disabled = false;
            console.log("Buzz button enabled");
          }

          const buzzIndicator = document.getElementById("buzz-indicator");
          if (buzzIndicator) {
            buzzIndicator.style.display = "none";
          }
        },

        handleBuzzReceived(data) {
          console.log("🔔 Buzz received from:", data.user);
          const buzzIndicator = document.getElementById("buzz-indicator");
          if (buzzIndicator) {
            buzzIndicator.innerHTML = `${data.user} buzzed in!`;
            buzzIndicator.style.display = "block";
          }

          const buzzButton = document.getElementById("buzz-button");
          if (buzzButton) {
            buzzButton.disabled = true;
          }

          const answerForm = document.getElementById("answer-form");
          if (answerForm) {
            answerForm.dataset.buzzId = data.buzz_id;
            answerForm.style.display = "block";
          }
        },

        handleAnswerSubmitted(data) {
          console.log("✅ Answer submitted:", data);
          const buzzIndicator = document.getElementById("buzz-indicator");
          if (buzzIndicator) {
            buzzIndicator.innerHTML = `${data.user} answered: "${
              data.answer
            }" - ${data.correct ? "Correct!" : "Incorrect"}`;
          }

          const buzzButton = document.getElementById("buzz-button");
          if (buzzButton) {
            buzzButton.disabled = false;
          }

          const answerForm = document.getElementById("answer-form");
          if (answerForm) {
            answerForm.style.display = "none";
          }
        },
      }
    );

    console.log("Room channel created:", roomChannel);
    return roomChannel;
  }

  // Create the initial connection immediately
  console.log("Creating initial connection...");
  roomChannel = createRoomChannel();

  window.addEventListener("beforeunload", () => {
    roomChannel.unsubscribe();
    roomChannel = null;
  });

  // Make it available globally
  window.roomChannel = roomChannel;

  return true;
}

window.reconnectToRoom = () => {
  console.log("Manual reconnect triggered");
  connect();
};

if (!connect()) {
  reconnectAttempts = 1;
  if (reconnectAttempts < maxReconnectAttempts) {
    reconnectAttempts++;
    console.log(
      `🔄 Attempting to reconnect (${reconnectAttempts}/${maxReconnectAttempts})...`
    );
    setTimeout(() => connect(), 1000 * reconnectAttempts);
  } else {
    console.log("Max reconnect attempts reached");
    const statusElement = document.getElementById("connection-status");
    if (statusElement) {
      statusElement.textContent = "Connection rejected - try refreshing";
      statusElement.className = "connection-status rejected";
    }
  }
}
