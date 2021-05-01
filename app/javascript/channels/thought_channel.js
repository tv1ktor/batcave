import consumer from "./consumer";

consumer.subscriptions.create(
  { channel: "ThoughtChannel" },
  {
    connected() {
      console.log("Connected to thoughts");
    },

    disconnected() {
      console.log("Disconnected from thoughts");
    },

    received(thought_html) {
      this.prependThought(thought_html);
    },

    prependThought(thought_html) {
      let el = document.getElementById("thoughts-container");
      el.innerHTML = thought_html + el.innerHTML;
    },
  }
);
