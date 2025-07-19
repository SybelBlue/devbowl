import consumer from "channels/consumer"

const roomChannel = consumer.subscriptions.create(
  { channel: "RoomChannel", room_id: document.dataset.roomId },
  {
    connected() {
      console.info("Connected to room")
    },

    disconnected() {
      console.info("Disconnected from room")
    },

    received(data) {
      switch(data.type) {
        case 'user_joined':
          this.handleUserJoined(data)
          break
        case 'buzz_received':
          this.handleBuzzReceived(data)
          break
        case 'answer_submitted':
          this.handleAnswerSubmitted(data)
          break
      }
    },

    buzzIn() {
      this.perform('buzz_in', {})
    },

    submitAnswer(buzzId, answer) {
      this.perform('submit_answer', { buzz_id: buzzId, answer: answer })
    },

    handleBuzzReceived(data) {
      // Pause reading, show who buzzed
      document.getElementById('buzz-indicator').innerHTML = `${data.user} buzzed in!`
      document.getElementById('buzz-button').disabled = true
      // Show answer form for the person who buzzed
    },

    handleAnswerSubmitted(data) {
      // Show the answer and whether it was correct
      // Re-enable buzz button for next question
      document.getElementById('buzz-button').disabled = false
    }
  }
)

// Make it available globally
window.roomChannel = roomChannel
