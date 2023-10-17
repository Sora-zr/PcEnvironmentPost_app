document.addEventListener('turbo:load', () => {
    const flashWindow = document.getElementsByClassName("flash-window")[0];
    if (flashWindow) {
        flashWindowToggle();
        setTimeout(flashWindowToggle, 2000)
        // document.getElementsByClassName("flash-window-delete")[0].addEventListener('click', flashWindowToggle);
    }
    function flashWindowToggle()
    {
        flashWindow.classList.toggle("hidden");
    }
});

