// --- INITIALIZE LUCIDE ICONS ---
lucide.createIcons();

// --- NAVBAR SCRIPT ---
window.addEventListener('scroll', function () {
    const navbar = document.getElementById('navbar');
    if (window.scrollY > 10) {
        navbar.classList.add('shadow-lg');
    } else {
        navbar.classList.remove('shadow-lg');
    }
});

// --- MOBILE NAVIGATION ---
function initMobileNavigation() {
    const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
    const mobileMenu = document.querySelector('.mobile-menu');
    
    if (mobileMenuBtn && mobileMenu) {
        mobileMenuBtn.addEventListener('click', function() {
            mobileMenu.classList.toggle('hidden');
            
            // Toggle hamburger icon
            const hamburgerIcon = mobileMenuBtn.querySelector('.hamburger-icon');
            const closeIcon = mobileMenuBtn.querySelector('.close-icon');
            
            if (mobileMenu.classList.contains('hidden')) {
                hamburgerIcon?.classList.remove('hidden');
                closeIcon?.classList.add('hidden');
            } else {
                hamburgerIcon?.classList.add('hidden');
                closeIcon?.classList.remove('hidden');
            }
        });
        
        // Close mobile menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!mobileMenuBtn.contains(event.target) && !mobileMenu.contains(event.target)) {
                mobileMenu.classList.add('hidden');
                const hamburgerIcon = mobileMenuBtn.querySelector('.hamburger-icon');
                const closeIcon = mobileMenuBtn.querySelector('.close-icon');
                hamburgerIcon?.classList.remove('hidden');
                closeIcon?.classList.add('hidden');
            }
        });
    }
}

// Enhanced smooth scrolling for navigation links
function initSmoothScrolling() {
    const navLinks = document.querySelectorAll('nav a[href^="#"]');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                const headerHeight = document.getElementById('navbar')?.offsetHeight || 0;
                const targetPosition = targetElement.offsetTop - headerHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// Modal functions
function openModal(modalId) {
    document.getElementById(modalId).classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}

function closeModal(modalId) {
    document.getElementById(modalId).classList.add('hidden');
    document.body.style.overflow = 'auto';
}

// Close modals with Escape key
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        const modals = document.querySelectorAll('[id$="-modal"]');
        modals.forEach(modal => {
            modal.classList.add('hidden');
        });
        document.body.style.overflow = 'auto';
    }
});

// Brain/Neuron Animation - Pharos AI Theme
// This creates an animated neural network visualization

function initBrainAnimation(canvas) {
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    let neurons = [];
    let pulses = [];

    // Seeded random number generator for deterministic patterns
    function seededRandom(seed) {
        let x = Math.sin(seed++) * 10000;
        return x - Math.floor(x);
    }

    // Get seed from canvas attribute or use random seed
    const seedAttribute = canvas.getAttribute('data-seed');
    let seed = seedAttribute ? parseInt(seedAttribute) : Math.floor(Math.random() * 1000000);
    let seedCounter = seed;

    // Seeded random function to replace Math.random()
    function random() {
        return seededRandom(seedCounter++);
    }

    function setCanvasSize() {
        const container = canvas.parentElement;
        const dpr = window.devicePixelRatio || 1;

        // Get the display size (CSS pixels)
        const displayWidth = container.offsetWidth;
        const displayHeight = container.offsetHeight;

        // Set the canvas display size
        canvas.style.width = displayWidth + 'px';
        canvas.style.height = displayHeight + 'px';

        // Set the canvas actual size (accounting for device pixel ratio)
        canvas.width = displayWidth * dpr;
        canvas.height = displayHeight * dpr;

        // Scale the drawing context to account for device pixel ratio
        ctx.scale(dpr, dpr);
    }

    class Neuron {
        constructor(x, y) {
            this.x = x;
            this.y = y;
            this.connections = [];
            this.pulse = 0;
        }

        draw() {
            ctx.beginPath();
            ctx.arc(this.x, this.y, 4 + this.pulse, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(238, 54, 109, ${0.8 + this.pulse * 0.2})`;
            ctx.fill();

            // Draw connections
            ctx.strokeStyle = 'rgba(238, 54, 109, 0.3)';
            ctx.lineWidth = 1;
            this.connections.forEach(neuron => {
                ctx.beginPath();
                ctx.moveTo(this.x, this.y);
                ctx.lineTo(neuron.x, neuron.y);
                ctx.stroke();
            });

            this.pulse *= 0.95;
        }

        addConnection(neuron) {
            this.connections.push(neuron);
        }
    }

    class Pulse {
        constructor(startNeuron, endNeuron) {
            this.startNeuron = startNeuron;
            this.endNeuron = endNeuron;
            this.progress = 0;
            this.speed = 0.02;
        }

        update() {
            this.progress += this.speed;

            if (this.progress >= 1) {
                this.endNeuron.pulse = 1;
                return false;
            }

            return true;
        }

        draw() {
            const x = this.startNeuron.x + (this.endNeuron.x - this.startNeuron.x) * this.progress;
            const y = this.startNeuron.y + (this.endNeuron.y - this.startNeuron.y) * this.progress;

            ctx.beginPath();
            ctx.arc(x, y, 3, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(241, 131, 34, 0.9)';
            ctx.fill();

            ctx.beginPath();
            ctx.arc(x, y, 8, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(241, 131, 34, 0.3)';
            ctx.fill();
        }
    }

    function initNeurons() {
        setCanvasSize();
        neurons = [];
        pulses = [];

        // Reset seed counter for consistent pattern generation
        seedCounter = seed;
        console.log(`Using brain seed: ${seed}`);

        // Get neuron count from data attribute or use default
        const neuronCount = parseInt(canvas.getAttribute('data-neuron-count')) || 12;
        const centerX = canvas.offsetWidth / 2;
        const centerY = canvas.offsetHeight / 2;
        const maxWidth = canvas.offsetWidth;
        const maxHeight = canvas.offsetHeight;

        // Create neurons distributed across the entire canvas
        for (let i = 0; i < neuronCount; i++) {
            // Mix structured and random placement for good distribution
            const structuredAngle = (i / neuronCount) * Math.PI * 2;
            const randomAngle = random() * Math.PI * 2;

            // Blend structured and random angles
            const angle = structuredAngle + (randomAngle - structuredAngle) * 0.3;

            // Use full canvas area with bias towards center
            const radiusBias = Math.pow(random(), 0.4); // Gentle center bias
            const maxRadius = Math.min(maxWidth, maxHeight) * 0.45; // Use 45% of canvas size
            const distance = maxRadius * radiusBias;

            // Additional random offset to fill corners and edges
            const extraRandomX = (random() - 0.5) * maxWidth * 0.3;
            const extraRandomY = (random() - 0.5) * maxHeight * 0.3;

            let x = centerX + Math.cos(angle) * distance + extraRandomX;
            let y = centerY + Math.sin(angle) * distance + extraRandomY;

            // Ensure neurons stay within canvas bounds with small margin
            const margin = 20;
            x = Math.max(margin, Math.min(maxWidth - margin, x));
            y = Math.max(margin, Math.min(maxHeight - margin, y));

            neurons.push(new Neuron(x, y));
        }

        // Create connections based on canvas size
        const maxConnectionDistance = Math.min(maxWidth, maxHeight) * 0.25; // 25% of canvas size

        // First pass: create connections based on proximity and randomness
        neurons.forEach((neuron, index) => {
            // Connect to nearby neurons
            neurons.forEach((otherNeuron, otherIndex) => {
                if (index !== otherIndex) {
                    const distance = Math.sqrt(
                        Math.pow(neuron.x - otherNeuron.x, 2) +
                        Math.pow(neuron.y - otherNeuron.y, 2)
                    );

                    if (distance < maxConnectionDistance && random() < 0.6) {
                        neuron.addConnection(otherNeuron);
                    }
                }
            });
        });

        // Second pass: ensure ALL neurons have at least one connection
        neurons.forEach((neuron, index) => {
            if (neuron.connections.length === 0) {
                // Find the closest neuron and connect to it
                let closestNeuron = null;
                let closestDistance = Infinity;

                neurons.forEach((otherNeuron, otherIndex) => {
                    if (index !== otherIndex) {
                        const distance = Math.sqrt(
                            Math.pow(neuron.x - otherNeuron.x, 2) +
                            Math.pow(neuron.y - otherNeuron.y, 2)
                        );

                        if (distance < closestDistance) {
                            closestDistance = distance;
                            closestNeuron = otherNeuron;
                        }
                    }
                });

                if (closestNeuron) {
                    neuron.addConnection(closestNeuron);
                    // Make the connection bidirectional for better visual flow
                    if (!closestNeuron.connections.includes(neuron)) {
                        closestNeuron.addConnection(neuron);
                    }
                }
            }
        });
    }

    function animateNeurons() {
        ctx.clearRect(0, 0, canvas.offsetWidth, canvas.offsetHeight);

        // Update and draw pulses
        pulses = pulses.filter(pulse => {
            const alive = pulse.update();
            if (alive) pulse.draw();
            return alive;
        });

        // Draw neurons
        neurons.forEach(neuron => neuron.draw());

        // Randomly create new pulses
        if (Math.random() < 0.1 && pulses.length < 3) {
            const startNeuron = neurons[Math.floor(Math.random() * neurons.length)];
            if (startNeuron.connections.length > 0) {
                const endNeuron = startNeuron.connections[Math.floor(Math.random() * startNeuron.connections.length)];
                pulses.push(new Pulse(startNeuron, endNeuron));
            }
        }

        requestAnimationFrame(animateNeurons);
    }

    // Initialize and start animation
    window.addEventListener('resize', () => initNeurons());
    initNeurons();
    animateNeurons();
}

// Initialize all features
document.addEventListener('DOMContentLoaded', function() {
    initMobileNavigation();
    initSmoothScrolling();

    // Initialize brain animation if canvas exists
    const brainCanvas = document.getElementsByClassName('brain-canvas');
    if (brainCanvas.length > 0) {
        Array.from(brainCanvas).forEach(canvas => {
            initBrainAnimation(canvas);
        });
    }

    // Initialize particle canvas if it exists
    const particleCanvas = document.getElementsByClassName('particle-canvas');
    if (particleCanvas.length > 0) {
        Array.from(particleCanvas).forEach(canvas => {
            const p_ctx = canvas.getContext('2d');
            let particlesArray;
            function setParticleCanvasSize() { canvas.width = window.innerWidth; canvas.height = document.getElementById('home').offsetHeight; }
            class Particle {
                constructor(x, y, dX, dY, size, color) { this.x = x; this.y = y; this.directionX = dX; this.directionY = dY; this.size = size; this.color = color; }
                draw() { p_ctx.beginPath(); p_ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2, false); p_ctx.fillStyle = 'rgba(241, 131, 34, 0.5)'; p_ctx.fill(); }
                update() { if (this.x > canvas.width || this.x < 0) { this.directionX = -this.directionX; } if (this.y > canvas.height || this.y < 0) { this.directionY = -this.directionY; } this.x += this.directionX; this.y += this.directionY; this.draw(); }
            }
            function initParticles() { setParticleCanvasSize(); particlesArray = []; let num = (canvas.height * canvas.width) / 9000; for (let i = 0; i < num; i++) { let size = (Math.random() * 2) + 1; let x = (Math.random() * ((canvas.width - size * 2) - (size * 2)) + size * 2); let y = (Math.random() * ((canvas.height - size * 2) - (size * 2)) + size * 2); let dX = (Math.random() * .4) - 0.2; let dY = (Math.random() * .4) - 0.2; particlesArray.push(new Particle(x, y, dX, dY, size, '#f18322')); } }
            function animateParticles() { requestAnimationFrame(animateParticles); p_ctx.clearRect(0, 0, canvas.width, canvas.height); for (let i = 0; i < particlesArray.length; i++) { particlesArray[i].update(); } connectParticles(); }
            function connectParticles() { let opacity = 1; for (let a = 0; a < particlesArray.length; a++) { for (let b = a; b < particlesArray.length; b++) { let dist = ((particlesArray[a].x - particlesArray[b].x) ** 2) + ((particlesArray[a].y - particlesArray[b].y) ** 2); if (dist < (canvas.width / 7) * (canvas.height / 7)) { opacity = 1 - (dist / 20000); p_ctx.strokeStyle = 'rgba(238, 54, 109,' + opacity + ')'; p_ctx.lineWidth = 1; p_ctx.beginPath(); p_ctx.moveTo(particlesArray[a].x, particlesArray[a].y); p_ctx.lineTo(particlesArray[b].x, particlesArray[b].y); p_ctx.stroke(); } } } }
            window.addEventListener('resize', () => initParticles());
            initParticles();
            animateParticles();
        });
    }
});
