// Brain/Neuron Animation - Pharos AI Theme
// This creates an animated neural network visualization

function initBrainAnimation(canvasId) {
    const canvas = document.getElementById(canvasId);
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
