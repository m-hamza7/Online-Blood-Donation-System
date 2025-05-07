<script>
    document.addEventListener('DOMContentLoaded', () => {
        const links = document.querySelectorAll('a');
        const transitionElement = document.querySelector('.page-transition');

        // Add click event to all links
        links.forEach(link => {
            link.addEventListener('click', e => {
                // Ensure it’s an internal link
                if (link.href.startsWith(window.location.origin)) {
                    e.preventDefault(); // Prevent default navigation
                    const targetURL = link.href;

                    // Show the transition
                    transitionElement.classList.add('active');

                    // Wait for the animation to complete, then navigate
                    setTimeout(() => {
                        window.location.href = targetURL;
                    }, 2000); // Match this delay with the animation duration
                }
            });
        });
    });
</script>
