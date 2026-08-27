<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Delta Mobile - Interactive Bone Dragon Studio</title>
    <style>
        * {
            box-sizing: border-box;
            user-select: none;
            -webkit-user-select: none;
            -webkit-touch-callout: none;
        }
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: #030308;
            touch-action: none;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        canvas {
            display: block;
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 1; /* Canvas nằm dưới cùng */
        }

        /* Nút mở/đóng menu - Đảm bảo z-index cao nhất */
        #delta-menu-toggle {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 99999;
            background: linear-gradient(135deg, #111122, #1a1a3a);
            border: 2px solid #d4af37;
            color: #d4af37;
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            font-weight: bold;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.8), 0 0 12px rgba(212, 175, 55, 0.4);
            cursor: pointer;
        }
        #delta-menu-toggle:active {
            transform: scale(0.9);
        }

        /* Hộp Menu chính - Đảm bảo z-index cực cao */
        #delta-menu-container {
            position: fixed;
            top: 82px;
            left: 20px;
            width: 280px;
            background: rgba(10, 10, 22, 0.95);
            border: 1px solid rgba(212, 175, 55, 0.5);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 16px;
            padding: 16px;
            z-index: 99998;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.85);
            transition: opacity 0.25s ease, transform 0.25s ease;
            opacity: 0;
            transform: translateY(-10px) scale(0.95);
            pointer-events: none;
        }
        #delta-menu-container.active {
            opacity: 1;
            transform: translateY(0) scale(1);
            pointer-events: auto;
        }

        .menu-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            padding-bottom: 10px;
            margin-bottom: 12px;
        }
        .menu-title {
            color: #fff;
            font-size: 14px;
            font-weight: bold;
            letter-spacing: 1px;
            text-shadow: 0 0 8px rgba(212, 175, 55, 0.5);
        }
        .menu-badge {
            background: #d4af37;
            color: #030308;
            font-size: 9px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 4px;
        }

        .menu-section {
            margin-bottom: 12px;
        }
        .menu-label {
            color: #8a8ab0;
            font-size: 11px;
            margin-bottom: 6px;
            display: flex;
            justify-content: space-between;
        }
        
        .menu-btn {
            width: 100%;
            background: linear-gradient(135deg, #1f1f3a, #2a2a5a);
            border: 1px solid rgba(212, 175, 55, 0.3);
            color: #fff;
            padding: 11px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 8px;
            text-align: center;
        }
        .menu-btn:active {
            background: #d4af37;
            color: #030308;
        }
        .menu-btn.active-mode {
            border-color: #00ffcc;
            color: #00ffcc;
        }

        .menu-footer {
            text-align: center;
            font-size: 10px;
            color: #555577;
            margin-top: 8px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 8px;
        }
    </style>
</head>
<body>

    <div id="delta-menu-toggle">⚡</div>

    <div id="delta-menu-container">
        <div class="menu-header">
            <span class="menu-title">DELTA DRAGON HUB</span>
            <span class="menu-badge">PRO</span>
        </div>

        <div class="menu-section">
            <div class="menu-label"><span>Hiệu ứng Khung Xương</span><span>Trạng thái: Bật</span></div>
            <button class="menu-btn active-mode" id="btnToggleAnim">Dừng / Chạy Animation</button>
        </div>

        <div class="menu-section">
            <div class="menu-label"><span>Tùy chỉnh hệ thống</span></div>
            <button class="menu-btn" id="btnResetPos">Đưa Rồng Về Giữa</button>
            <button class="menu-btn" id="btnColorTheme">Đổi Giao Diện Màu Sắc</button>
        </div>

        <div class="menu-footer">
            Tương thích GitHub Pages & Delta Mobile
        </div>
    </div>

    <canvas id="dragonCanvas"></canvas>

    <script>
        // Xử lý sự kiện bấm menu an toàn cho Mobile (tránh xung đột cảm ứng)
        const toggleBtn = document.getElementById('delta-menu-toggle');
        const menuContainer = document.getElementById('delta-menu-container');

        function toggleMenu(e) {
            if (e) e.stopPropagation();
            menuContainer.classList.toggle('active');
        }

        toggleBtn.addEventListener('touchstart', toggleMenu, { passive: false });
        toggleBtn.addEventListener('click', toggleMenu);

        // Các nút chức năng trong menu
        let isRunning = true;
        const btnToggleAnim = document.getElementById('btnToggleAnim');
        btnToggleAnim.addEventListener('click', () => {
            isRunning = !isRunning;
            if (isRunning) {
                btnToggleAnim.classList.add('active-mode');
                btnToggleAnim.innerText = "Dừng / Chạy Animation";
            } else {
                btnToggleAnim.classList.remove('active-mode');
                btnToggleAnim.innerText = "Tiếp tục chạy";
            }
        });

        let colorTheme = 0;
        document.getElementById('btnColorTheme').addEventListener('click', () => {
            colorTheme = (colorTheme + 1) % 3;
        });

        document.getElementById('btnResetPos').addEventListener('click', () => {
            if (window.appInstance) {
                window.appInstance.resetDragon();
            }
            menuContainer.classList.remove('active');
        });

        /**
         * Core Vector2D & Animation Logic
         */
        class Vector2D {
            constructor(x = 0, y = 0) { this.x = x; this.y = y; }
            set(x, y) { this.x = x; this.y = y; return this; }
            dist(v) { let dx = this.x - v.x; let dy = this.y - v.y; return Math.sqrt(dx * dx + dy * dy); }
            normalize() {
                let m = Math.sqrt(this.x * this.x + this.y * this.y);
                if (m !== 0) { this.x /= m; this.y /= m; }
                return this;
            }
        }

        class Particle {
            constructor(x, y, vx, vy, color, size, life) {
                this.pos = new Vector2D(x, y);
                this.vel = new Vector2D(vx, vy);
                this.color = color;
                this.size = size;
                this.maxLife = life;
                this.life = life;
                this.alpha = 1;
            }
            update() {
                this.pos.x += this.vel.x;
                this.pos.y += this.vel.y;
                this.life--;
                this.alpha = this.life / this.maxLife;
                this.size *= 0.98;
            }
            draw(ctx) {
                ctx.save();
                ctx.globalAlpha = Math.max(0, this.alpha);
                ctx.fillStyle = this.color;
                ctx.shadowColor = this.color;
                ctx.shadowBlur = 8;
                ctx.beginPath();
                ctx.arc(this.pos.x, this.pos.y, Math.max(0.5, this.size), 0, Math.PI * 2);
                ctx.fill();
                ctx.restore();
            }
        }

        class ParticleSystem {
            constructor() { this.particles = []; }
            add(x, y, vx, vy, color, size, life) {
                this.particles.push(new Particle(x, y, vx, vy, color, size, life));
            }
            updateAndDraw(ctx) {
                for (let i = this.particles.length - 1; i >= 0; i--) {
                    let p = this.particles[i];
                    p.update();
                    p.draw(ctx);
                    if (p.life <= 0 || p.size <= 0.2) this.particles.splice(i, 1);
                }
            }
        }

        class BackgroundManager {
            constructor(w, h) { this.init(w, h); }
            init(w, h) {
                this.stars = [];
                let count = Math.floor((w * h) / 9000);
                for (let i = 0; i < count; i++) {
                    this.stars.push({
                        x: Math.random() * w, y: Math.random() * h,
                        size: Math.random() * 1.5 + 0.4,
                        alpha: Math.random() * 0.6 + 0.2,
                        speed: Math.random() * 0.01 + 0.003
                    });
                }
            }
            draw(ctx, w, h) {
                ctx.fillStyle = '#030308';
                ctx.fillRect(0, 0, w, h);
                for (let s of this.stars) {
                    s.alpha += Math.sin(Date.now() * s.speed) * 0.008;
                    let a = Math.max(0.1, Math.min(1, s.alpha));
                    ctx.save();
                    ctx.fillStyle = colorTheme === 1 ? `rgba(0, 255, 204, ${a})` : (colorTheme === 2 ? `rgba(255, 50, 100, ${a})` : `rgba(212, 175, 55, ${a})`);
                    ctx.beginPath();
                    ctx.arc(s.x, s.y, s.size, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.restore();
                }
            }
        }

        class BoneNode {
            constructor(x, y, size) {
                this.pos = new Vector2D(x, y);
                this.size = size;
                this.angle = 0;
            }
        }

        class BoneDragon {
            constructor(startX, startY, totalNodes, speed) {
                this.speed = speed;
                this.nodes = [];
                this.target = new Vector2D(startX, startY);
                this.particleSystem = new ParticleSystem();
                for (let i = 0; i < totalNodes; i++) {
                    this.nodes.push(new BoneNode(startX, startY + i * 10, Math.max(4, 30 - i * 0.8)));
                }
            }

            setTarget(x, y) { this.target.set(x, y); }

            update() {
                if (!isRunning) return;
                let head = this.nodes[0];
                let dist = head.pos.dist(this.target);

                if (dist > 0.1) {
                    let dir = new Vector2D(this.target.x - head.pos.x, this.target.y - head.pos.y).normalize();
                    head.pos.x += dir.x * Math.min(dist, this.speed * 1.5);
                    head.pos.y += dir.y * Math.min(dist, this.speed * 1.5);
                }

                let curX = head.pos.x;
                let curY = head.pos.y;

                for (let i = 0; i < this.nodes.length; i++) {
                    let node = this.nodes[i];
                    if (i > 0) {
                        let dx = node.pos.x - curX;
                        let dy = node.pos.y - curY;
                        let ang = Math.atan2(dy, dx);
                        node.angle = ang;
                        let spacing = node.size * 0.65;
                        node.pos.x = curX + spacing * Math.cos(ang);
                        node.pos.y = curY + spacing * Math.sin(ang);
                    } else if (this.nodes.length > 1) {
                        node.angle = Math.atan2(this.nodes[1].pos.y - head.pos.y, this.nodes[1].pos.x - head.pos.x);
                    }
                    curX = node.pos.x;
                    curY = node.pos.y;
                }

                if (Math.random() < 0.5) {
                    let pX = head.pos.x + Math.cos(head.angle) * 15;
                    let pY = head.pos.y + Math.sin(head.angle) * 15;
                    let cStr = colorTheme === 1 ? '#ff00ff' : (colorTheme === 2 ? '#ffaa00' : '#00ffcc');
                    this.particleSystem.add(pX, pY, (Math.random() - 0.5) * 3, (Math.random() - 0.5) * 3, cStr, Math.random() * 4 + 2, 35);
                }
            }

            draw(ctx) {
                this.particleSystem.updateAndDraw(ctx);
                let mainColor = colorTheme === 1 ? '#00ffcc' : (colorTheme === 2 ? '#ff3366' : '#d4af37');

                ctx.save();
                ctx.beginPath();
                ctx.strokeStyle = mainColor;
                ctx.lineWidth = 3;
                ctx.shadowColor = mainColor;
                ctx.shadowBlur = 10;
                for (let i = 0; i < this.nodes.length; i++) {
                    let n = this.nodes[i];
                    if (i === 0) ctx.moveTo(n.pos.x, n.pos.y);
                    else ctx.lineTo(n.pos.x, n.pos.y);
                }
                ctx.stroke();
                ctx.restore();

                for (let i = 0; i < this.nodes.length; i++) {
                    let n = this.nodes[i];
                    ctx.save();
                    ctx.translate(n.pos.x, n.pos.y);
                    ctx.rotate(n.angle);

                    if (i === 0) {
                        ctx.fillStyle = '#ffffff';
                        ctx.shadowColor = '#ffffff';
                        ctx.shadowBlur = 12;
                        ctx.beginPath();
                        ctx.ellipse(0, 0, 16, 9, 0, 0, Math.PI * 2);
                        ctx.fill();

                        ctx.fillStyle = mainColor;
                        ctx.beginPath();
                        ctx.arc(5, -4, 2, 0, Math.PI * 2);
                        ctx.arc(5, 4, 2, 0, Math.PI * 2);
                        ctx.fill();
                    } else if (i % 2 === 0 && i < this.nodes.length - 4) {
                        ctx.strokeStyle = '#e0e0e0';
                        ctx.lineWidth = 1.5;
                        ctx.beginPath();
                        let span = n.size * 1.3;
                        ctx.moveTo(0, -span); ctx.lineTo(span * 0.35, -span * 1.6);
                        ctx.moveTo(0, span); ctx.lineTo(span * 0.35, span * 1.6);
                        ctx.stroke();

                        ctx.fillStyle = '#b0bec5';
                        ctx.beginPath();
                        ctx.arc(0, 0, n.size * 0.4, 0, Math.PI * 2);
                        ctx.fill();
                    }
                    ctx.restore();
                }
            }
        }

        class Application {
            constructor() {
                this.canvas = document.getElementById('dragonCanvas');
                this.ctx = this.canvas.getContext('2d');
                this.resize();

                this.bgManager = new BackgroundManager(this.width, this.height);
                this.dragon = new BoneDragon(this.width / 2, this.height / 2, 30, 6);

                this.initEvents();
                this.loop();
            }

            resize() {
                this.width = window.innerWidth;
                this.height = window.innerHeight;
                this.canvas.width = this.width;
                this.canvas.height = this.height;
                if (this.bgManager) this.bgManager.init(this.width, this.height);
            }

            resetDragon() {
                for (let n of this.dragon.nodes) {
                    n.pos.set(this.width / 2, this.height / 2);
                }
                this.dragon.target.set(this.width / 2, this.height / 2);
            }

            initEvents() {
                window.addEventListener('resize', () => this.resize());

                const updateCoords = (x, y) => {
                    this.dragon.setTarget(x, y);
                };

                window.addEventListener('mousemove', (e) => updateCoords(e.clientX, e.clientY));
                window.addEventListener('touchmove', (e) => {
                    if (e.touches.length > 0) updateCoords(e.touches[0].clientX, e.touches[0].clientY);
                }, { passive: true });
                window.addEventListener('touchstart', (e) => {
                    if (e.touches.length > 0) updateCoords(e.touches[0].clientX, e.touches[0].clientY);
                }, { passive: true });
            }

            loop() {
                this.ctx.fillStyle = 'rgba(3, 3, 8, 0.22)';
                this.ctx.fillRect(0, 0, this.width, this.height);

                this.bgManager.draw(this.ctx, this.width, this.height);
                this.dragon.update();
                this.dragon.draw(this.ctx);

                requestAnimationFrame(() => this.loop());
            }
        }

        window.addEventListener('DOMContentLoaded', () => {
            window.appInstance = new Application();
        });
    </script>
</body>
</html>
