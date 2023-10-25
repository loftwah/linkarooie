document.getElementById('navigateBtn').addEventListener('click', navigate);
document.getElementById('addShortcutBtn').addEventListener('click', addShortcut);
document.getElementById('quickSearch').addEventListener('keydown', function(e) {
    if (e.keyCode === 13) {
        navigate();
    }
});

function navigate() {
    let value = document.getElementById('quickSearch').value;
    if (value.startsWith("http://") || value.startsWith("https://")) {
        window.location.href = value;
    } else {
        window.location.href = 'https://www.google.com/search?q=' + value;
    }
}

// Load shortcuts from local storage and display them
function loadShortcuts() {
    chrome.storage.local.get('shortcuts', function(data) {
        const shortcuts = data.shortcuts || [];
        const container = document.getElementById('shortcuts');
        container.innerHTML = '';

        shortcuts.forEach(shortcut => {
            let link = document.createElement('a');
            link.href = shortcut.url;
            link.innerText = shortcut.name;

            let removeBtn = document.createElement('button');
            removeBtn.innerText = 'Remove';
            removeBtn.onclick = function() {
                removeShortcut(shortcut);
            };

            let div = document.createElement('div');
            div.appendChild(link);
            div.appendChild(removeBtn);
            container.appendChild(div);
        });
    });
}

loadShortcuts();

function addShortcut() {
    let name = document.getElementById('linkName').value;
    let url = document.getElementById('linkURL').value;
    if (name && (url.startsWith("http://") || url.startsWith("https://"))) {
        chrome.storage.local.get('shortcuts', function(data) {
            const shortcuts = data.shortcuts || [];
            shortcuts.push({ name: name, url: url });
            chrome.storage.local.set({ 'shortcuts': shortcuts }, function() {
                loadShortcuts();
            });
        });
    } else {
        alert('Invalid name or URL');
    }
}

function removeShortcut(shortcutToRemove) {
    chrome.storage.local.get('shortcuts', function(data) {
        let shortcuts = data.shortcuts || [];
        shortcuts = shortcuts.filter(shortcut => shortcut.url !== shortcutToRemove.url);
        chrome.storage.local.set({ 'shortcuts': shortcuts }, function() {
            loadShortcuts();
        });
    });
}
