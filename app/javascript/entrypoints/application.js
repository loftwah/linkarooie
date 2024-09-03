import Rails from "@rails/ujs";
import "chartkick/chart.js";
import "flowbite";

Rails.start();

console.log('Vite ⚡️ Rails');

// Linkarooie console messages
console.log('Linkarooie 🌐 Your ultimate link management tool');
console.log('Simplify your online presence with a single link.');
console.log('© 2024 Linkarooie. All rights reserved.');

// Easter egg for "iddqd"
(function () {
    let inputBuffer = '';

    // Listen for keypress events in the browser
    window.addEventListener('keydown', function (event) {
        inputBuffer += event.key;

        // Check if 'iddqd' was typed
        if (inputBuffer.toLowerCase().includes('iddqd')) {
            activateGodMode();
            inputBuffer = '';  // Reset buffer after activation
        }

        // Clear the buffer if it gets too long
        if (inputBuffer.length > 10) inputBuffer = inputBuffer.slice(-10);
    });

    function activateGodMode() {
        console.log('%c God Mode Activated! You are now invincible! ', 'background: #222; color: #bada55; font-size: 16px;');

        // ASCII art
        const asciiArt = `
+-----------------------------------------------------------------------------+
| |       |\\                                           -~ /     \\  /          |
|~~__     | \\                                         | \\/       /\\          /|
|    --   |  \\                                        | / \\    /    \\     /   |
|      |~_|   \\                                   \\___|/    \\/         /      |
|--__  |   -- |\\________________________________/~~\\~~|    /  \\     /     \\   |
|   |~~--__  |~_|____|____|____|____|____|____|/ /  \\/|\\ /      \\/          \\/|
|   |      |~--_|__|____|____|____|____|____|_/ /|    |/ \\    /   \\       /   |
|___|______|__|_||____|____|____|____|____|__[]/_|----|    \\/       \\  /      |
|  \\mmmm :   | _|___|____|____|____|____|____|___|  /\\|   /  \\      /  \\      |
|      B :_--~~ |_|____|____|____|____|____|____|  |  |\\/      \\ /        \\   |
|  __--P :  |  /                                /  /  | \\     /  \\          /\\|
|~~  |   :  | /                                 ~~~   |  \\  /      \\      /   |
|    |      |/                        .-.             |  /\\          \\  /     |
|    |      /                        |   |            |/   \\          /\\      |
|    |     /                        |     |            -_   \\       /    \\    |
+-----------------------------------------------------------------------------+
|          |  /|  |   |  2  3  4  | /~~~~~\\ |       /|    |_| ....  ......... |
|          |  ~|~ | % |           | | ~J~ | |       ~|~ % |_| ....  ......... |
|   AMMO   |  HEALTH  |  5  6  7  |  \\===/  |    ARMOR    |#| ....  ......... |
+-----------------------------------------------------------------------------+
        `;

        console.log(asciiArt);

        // Create a div to display Doom information
        const infoDiv = document.createElement('div');
        infoDiv.innerHTML = `
            <div style="position: fixed; bottom: 20px; right: 20px; background-color: #111; color: #fff; padding: 20px; border-radius: 10px; max-width: 300px; z-index: 1000;">
                <h3 style="margin: 0 0 10px 0;">You've unlocked a secret!</h3>
                <p>Doom is a 1993 first-person shooter game developed by id Software. It was created by John Carmack and John Romero, among others. The game is considered one of the most significant titles in video game history, pioneering immersive 3D graphics, networked multiplayer gaming, and support for custom mods and expansions.</p>
                <p>The "iddqd" command is a famous cheat code that grants invulnerability, often referred to as "God Mode".</p>
                <p>Fun Fact: The name "Doom" was inspired by a line from the movie "The Color of Money" starring Tom Cruise.</p>
                <button id="closeInfo" style="margin-top: 10px; padding: 5px 10px; background-color: #555; color: #fff; border: none; cursor: pointer;">Close</button>
            </div>
        `;
        document.body.appendChild(infoDiv);

        // Add event listener to the close button to remove the div
        document.getElementById('closeInfo').addEventListener('click', function() {
            document.body.removeChild(infoDiv);
        });
    }
})();

document.addEventListener('DOMContentLoaded', () => {
    const pathname = window.location.pathname;
    const userPagePattern = /^\/[^/]+$/;  // Matches any path with a single segment after the root
  
    if (userPagePattern.test(pathname)) {
      const hiddenLinksData = document.getElementById('hidden-links-data');
      
      if (hiddenLinksData) {
        const hiddenLinks = JSON.parse(hiddenLinksData.dataset.hiddenLinks);
  
        if (hiddenLinks.length > 0) {
          console.group('Hidden Links');
          hiddenLinks.forEach((link) => {
            console.log(`Title: ${link.title}, URL: ${link.url}`);
          });
          console.groupEnd();
        } else {
          console.log('No hidden links to display.');
        }
      }
    }
  });