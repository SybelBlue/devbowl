import consumer from "channels/consumer"

const roomElement = document.querySelector('[data-room-id]')
if (roomElement) {
  const roomChannel = consumer.subscriptions.create(
    { channel: "RoomChannel", room_id: roomElement.dataset.roomId },
    {
      connected() {
        console.log("Connected to room")
      },

      disconnected() {
        console.log("Disconnected from room")
      },

      received(data) {
        console.log("Received:", data)
        switch(data.type) {
          case 'question_started':
            this.handleQuestionStarted(data)
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

      handleQuestionStarted(data) {
        const questionContent = document.getElementById('question-content')
        questionContent.innerHTML = `
          <h3>${data.question.title}</h3>
          <p><strong>Toss-up:</strong> ${data.question.toss_up}</p>
          <p><em>Format: ${data.question.format}</em></p>
        `

        document.getElementById('buzz-button').disabled = false
        document.getElementById('buzz-indicator').style.display = 'none'
      },

      handleBuzzReceived(data) {
        document.getElementById('buzz-indicator').innerHTML = `${data.user} buzzed in!`
        document.getElementById('buzz-indicator').style.display = 'block'
        document.getElementById('buzz-button').disabled = true

        // Show answer form for the person who buzzed (you'd check if it's current user)
        const answerForm = document.getElementById('answer-form')
        answerForm.dataset.buzzId = data.buzz_id
        answerForm.style.display = 'block'
      },

      handleAnswerSubmitted(data) {
        document.getElementById('buzz-indicator').innerHTML =
          `${data.user} answered: "${data.answer}" - ${data.correct ? 'Correct!' : 'Incorrect'}`
        document.getElementById('buzz-button').disabled = false
        document.getElementById('answer-form').style.display = 'none'
      }
    }
  )

  // Make it available globally
  window.roomChannel = roomChannel
}