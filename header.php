<?php
ob_start();
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Handle theme toggle
if (isset($_POST['toggle_theme'])) {
    $currentTheme = $_SESSION['theme'] ?? 'light';
    $_SESSION['theme'] = ($currentTheme === 'light') ? 'dark' : 'light';
    header("Location: " . $_SERVER['REQUEST_URI']);
    exit();
}
$currentTheme = $_SESSION['theme'] ?? 'light';

// Parse user name from session
$userName = $_SESSION['user_name'] ?? '';
$nameParts = explode(' ', trim($userName), 2);

// Build user array from session
$user = [
    'first_name' => $nameParts[0] ?? 'User',
    'last_name' => $nameParts[1] ?? '',
    'designation' => trim($_SESSION['designation'] ?? 'Guest'),
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id'] ?? null
];
?>
<!DOCTYPE html>
<html lang="en" data-theme="<?php echo htmlspecialchars($currentTheme); ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($pageTitle ?? 'Dashboard'); ?></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="main-header">
    <div class="header-left">
        <button class="sidebar-toggle" aria-label="Toggle sidebar">
            <i class="fas fa-bars"></i>
        </button>
    </div>

    <!-- Enhanced Notification System -->
    <div class="notification-wrapper">
        <div class="notification-bell" id="notificationBell" aria-label="Notifications">
            <i class="fas fa-bell"></i>
            <span class="badge" id="notificationCount" style="display: none;">0</span>
        </div>
       
        <div class="notification-dropdown" id="notificationDropdown">
            <div class="notification-header">
                <h4>Notifications</h4>
                <div class="notification-actions">
                    <button id="refreshNotifications" class="btn-icon" title="Refresh">
                        <i class="fas fa-sync-alt"></i>
                    </button>
                    <button id="markAllRead" class="btn-icon" title="Mark all as read">
                        <i class="fas fa-check-double"></i>
                    </button>
                </div>
            </div>
           
            <div class="notification-filters">
                <button class="filter-btn active" data-filter="all">All</button>
                <button class="filter-btn" data-filter="unread">Unread</button>
            </div>
           
            <div class="notification-list" id="notificationList">
                <div class="notification-loading">
                    <i class="fas fa-spinner fa-spin"></i> Loading notifications...
                </div>
            </div>
           
            <div class="notification-footer">
                <div class="notification-stats" id="notificationStats">
                    Loading...
                </div>
            </div>
        </div>
    </div>

    <!-- Theme Toggle -->
    <div class="theme-toggle">
        <form method="POST" style="margin: 0;">
            <button type="submit" name="toggle_theme" class="theme-switch" aria-label="Toggle dark/light mode">
                <div class="theme-slider">
                    <span class="theme-icon">
                        <?php echo ($currentTheme === 'light') ? '🌞' : '🌙'; ?>
                    </span>
                </div>
            </button>
        </form>
    </div>

    <!-- User Info -->
    <div class="user-info">
        <span class="user-name">
            <?php echo htmlspecialchars($user['first_name'] . ' ' . $user['last_name']); ?>
        </span>
        <span class="role-badge">
            <?php echo htmlspecialchars(ucwords($user['designation'])); ?>
        </span>
    </div>

    <!-- Logout -->
    <a href="logout.php" class="logout-btn" aria-label="Logout">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
    </a>
</div>

<script>
// ==========================
// ENHANCED NOTIFICATION SYSTEM
// ==========================
class MobileNotificationSystem {
    constructor() {
        this.isLoading = false;
        this.currentFilter = 'all';
        this.notifications = [];
        this.pollingInterval = 30000; // 30 seconds
        this.pollingTimer = null;
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.loadNotifications();
        this.startPolling();
        this.updatePageTitle();
    }

    setupEventListeners() {
        const bell = document.getElementById('notificationBell');
        const dropdown = document.getElementById('notificationDropdown');
        const markAllRead = document.getElementById('markAllRead');
        const refreshBtn = document.getElementById('refreshNotifications');
        const filterBtns = document.querySelectorAll('.filter-btn');

        if (bell) {
            bell.addEventListener('click', (e) => {
                e.stopPropagation();
                this.toggleDropdown();
            });
            bell.addEventListener('touchstart', (e) => {
                e.preventDefault();
                this.toggleDropdown();
            }, { passive: false });
        }

        if (markAllRead) {
            markAllRead.addEventListener('click', (e) => {
                e.stopPropagation();
                this.markAllAsRead();
            });
        }

        if (refreshBtn) {
            refreshBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.loadNotifications();
            });
        }

        filterBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.setFilter(btn.dataset.filter);
            });
        });

        document.addEventListener('click', (e) => {
            if (dropdown && !dropdown.contains(e.target) && !bell.contains(e.target)) {
                this.closeDropdown();
            }
        });

        document.addEventListener('touchstart', (e) => {
            if (dropdown && !dropdown.contains(e.target) && !bell.contains(e.target)) {
                this.closeDropdown();
            }
        });

        if (dropdown) {
            dropdown.addEventListener('click', (e) => e.stopPropagation());
        }

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') this.closeDropdown();
        });

        window.addEventListener('orientationchange', () => {
            setTimeout(() => this.adjustDropdownPosition(), 300);
        });

        window.addEventListener('resize', () => this.adjustDropdownPosition());
    }

    toggleDropdown() {
        const dropdown = document.getElementById('notificationDropdown');
        const bell = document.getElementById('notificationBell');
        if (!dropdown || !bell) return;
        dropdown.classList.contains('active') ? this.closeDropdown() : this.openDropdown();
    }

    openDropdown() {
        const dropdown = document.getElementById('notificationDropdown');
        const bell = document.getElementById('notificationBell');
        if (!dropdown || !bell) return;
        dropdown.classList.add('active');
        this.adjustDropdownPosition();
        this.loadNotifications();
        document.body.classList.add('notification-open');
    }

    closeDropdown() {
        const dropdown = document.getElementById('notificationDropdown');
        if (!dropdown) return;
        dropdown.classList.remove('active');
        document.body.classList.remove('notification-open');
    }

    adjustDropdownPosition() {
        const dropdown = document.getElementById('notificationDropdown');
        const bell = document.getElementById('notificationBell');
        if (!dropdown || !bell || !dropdown.classList.contains('active')) return;

        if (window.innerWidth <= 768) {
            dropdown.style.left = '50%';
            dropdown.style.right = 'auto';
            dropdown.style.transform = 'translateX(-50%)';
        } else {
            dropdown.style.left = 'auto';
            dropdown.style.right = '0';
            dropdown.style.transform = 'none';
        }
    }

    setFilter(filter) {
        this.currentFilter = filter;
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.filter === filter);
        });
        this.renderNotifications();
    }

    async loadNotifications() {
        if (this.isLoading) return;
        this.isLoading = true;
        this.showLoadingState();

        try {
            console.log('🔔 Loading notifications from API...');
            
            const apiUrl = `notifications/notifications.php?action=get_notifications&limit=20&t=${Date.now()}`;
            console.log('API URL:', apiUrl);
            
            const response = await fetch(apiUrl);
            console.log('Response status:', response.status, response.statusText);
            
            // Get the raw response text first to see what's actually returned
            const responseText = await response.text();
            console.log('Raw response:', responseText.substring(0, 500)); // First 500 chars
            
            let data;
            try {
                data = JSON.parse(responseText);
            } catch (parseError) {
                console.error('❌ JSON Parse Error:', parseError);
                console.error('Raw response that failed to parse:', responseText);
                throw new Error(`Server returned invalid JSON. This usually means a PHP error. Check: ${apiUrl}`);
            }
            
            console.log('📊 Parsed data:', data);

            if (data.success) {
                this.notifications = data.notifications || [];
                this.updateNotificationCount(data.unreadCount || 0);
                this.renderNotifications();
                this.updateStats();
                console.log('✅ Notifications loaded successfully:', this.notifications.length);
            } else {
                console.error('❌ API returned error:', data.error, data.debug_info);
                this.showError('Failed to load notifications: ' + (data.error || 'Unknown error'));
            }
        } catch (error) {
            console.error('💥 Load error details:', error);
            
            // More specific error messages
            if (error.message.includes('invalid JSON')) {
                this.showError('Server error: Please check the notification system configuration');
            } else if (error.message.includes('Network error')) {
                this.showError('Network error: Cannot connect to server');
            } else {
                this.showError('Error loading notifications: ' + error.message);
            }
        } finally {
            this.isLoading = false;
        }
    }

    updateNotificationCount(unreadCount) {
        const countElement = document.getElementById('notificationCount');
        const bell = document.getElementById('notificationBell');

        if (countElement) {
            countElement.textContent = unreadCount;
            countElement.style.display = unreadCount > 0 ? 'flex' : 'none';
        }
        if (bell) bell.classList.toggle('has-unread', unreadCount > 0);
        this.updatePageTitle(unreadCount);
    }

    updatePageTitle(unreadCount = null) {
        if (unreadCount === null) {
            const el = document.getElementById('notificationCount');
            unreadCount = el ? parseInt(el.textContent) || 0 : 0;
        }
        const baseTitle = document.title.replace(/^\(\d+\)\s*/, '');
        document.title = unreadCount > 0 ? `(${unreadCount}) ${baseTitle}` : baseTitle;
    }

    renderNotifications() {
        const list = document.getElementById('notificationList');
        if (!list) return;

        let filtered = this.notifications;
        if (this.currentFilter === 'unread') {
            filtered = filtered.filter(n => !n.is_read);
        }

        if (filtered.length === 0) {
            list.innerHTML = `<div class="notification-empty">${this.currentFilter === 'unread' ? 'No unread notifications' : 'No notifications'}</div>`;
            return;
        }

        list.innerHTML = filtered.map(n => `
            <div class="notification-item ${n.is_read ? 'read' : 'unread'} priority-${n.priority}"
                 data-id="${n.id}" data-type="${n.type}">
                <div class="notification-icon ${this.getNotificationIconClass(n.type)}">
                    <i class="${this.getNotificationIcon(n.type)}"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">${this.escapeHtml(n.title)}</div>
                    <div class="notification-message">${this.escapeHtml(n.message)}</div>
                    <div class="notification-meta">
                        <span class="notification-time">${this.formatTime(n.created_at)}</span>
                        <span class="notification-category">${n.category}</span>
                        ${n.priority === 'urgent' ? '<span class="priority-badge urgent">URGENT</span>' : ''}
                        ${n.priority === 'high' ? '<span class="priority-badge high">HIGH</span>' : ''}
                    </div>
                    <div class="notification-actions-inline">
                        ${n.action_url ? `<a href="${n.action_url}" class="action-link" onclick="event.preventDefault(); window.notificationSystem.handleNotificationClick('${n.id}', '${n.type}')">View</a>` : ''}
                        ${!n.is_read ? `<button class="mark-read-btn" onclick="event.preventDefault(); window.notificationSystem.markAsRead('${n.id}')">Mark Read</button>` : ''}
                    </div>
                </div>
            </div>
        `).join('');

        this.setupTouchHandlers();
    }

    setupTouchHandlers() {
        document.querySelectorAll('.notification-item').forEach(item => {
            item.addEventListener('touchend', (e) => {
                e.preventDefault();
                this.handleNotificationClick(item.dataset.id, item.dataset.type);
            });
        });
    }

    async handleNotificationClick(id, type) {
        await this.markAsRead(id);
        const n = this.notifications.find(x => x.id == id);
        if (n?.action_url) {
            if (window.innerWidth <= 768) this.closeDropdown();
            window.location.href = n.action_url;
        }
    }

    async markAsRead(id) {
        try {
            const form = new FormData();
            form.append('notification_id', id);
            const res = await fetch('notifications/notifications.php?action=mark_as_read', {
                method: 'POST',
                body: form
            });
            
            // Check for JSON parsing issues here too
            const responseText = await res.text();
            let data;
            try {
                data = JSON.parse(responseText);
            } catch (e) {
                console.error('Mark as read JSON parse error:', e);
                throw new Error('Invalid server response');
            }
            
            if (data.success) {
                const n = this.notifications.find(x => x.id == id);
                if (n) n.is_read = 1;
                this.renderNotifications();
                this.updateNotificationCount(data.unreadCount);
                this.updateStats();
            } else {
                console.error('Mark as read failed:', data.error);
            }
        } catch (e) { 
            console.error('Mark as read error:', e);
            this.showTempMessage('Failed to mark as read');
        }
    }

    async markAllAsRead() {
        try {
            const res = await fetch('notifications/notifications.php?action=mark_all_read', { method: 'POST' });
            
            // Check for JSON parsing issues
            const responseText = await res.text();
            let data;
            try {
                data = JSON.parse(responseText);
            } catch (e) {
                console.error('Mark all read JSON parse error:', e);
                throw new Error('Invalid server response');
            }
            
            if (data.success) {
                this.notifications.forEach(n => n.is_read = 1);
                this.renderNotifications();
                this.updateNotificationCount(0);
                this.updateStats();
                this.showTempMessage('All notifications marked as read');
            } else {
                throw new Error(data.error || 'Failed to mark all as read');
            }
        } catch (e) {
            console.error('Mark all read error:', e);
            this.showTempMessage('Failed to mark all as read: ' + e.message);
        }
    }

    getUnreadCount() {
        return this.notifications.filter(n => !n.is_read).length;
    }

    updateStats() {
        const el = document.getElementById('notificationStats');
        if (el) {
            const unread = this.getUnreadCount();
            const total = this.notifications.length;
            el.textContent = `${unread} unread • ${total} total`;
            el.className = `notification-stats ${unread > 0 ? 'has-unread' : 'all-read'}`;
        }
    }

    showLoadingState() {
        const list = document.getElementById('notificationList');
        if (list) {
            list.innerHTML = `
                <div class="notification-loading">
                    <i class="fas fa-spinner fa-spin"></i> 
                    <div>Loading notifications...</div>
                    <small>Checking server connection</small>
                </div>
            `;
        }
    }

    showError(msg) {
        const list = document.getElementById('notificationList');
        if (list) {
            list.innerHTML = `
                <div class="notification-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>${msg}</div>
                    <button class="retry-btn" onclick="window.notificationSystem.loadNotifications()">
                        <i class="fas fa-redo"></i> Retry
                    </button>
                </div>
            `;
        }
    }

    showTempMessage(msg) {
        const existing = document.querySelector('.notification-temp-message');
        if (existing) existing.remove();

        const el = document.createElement('div');
        el.className = 'notification-temp-message';
        el.innerHTML = `
            <div class="temp-message-content">
                <i class="fas fa-check-circle"></i>
                <span>${msg}</span>
            </div>
        `;
        document.body.appendChild(el);
        
        setTimeout(() => {
            el.classList.add('fade-out');
            setTimeout(() => el.remove(), 300);
        }, 3000);
    }

    startPolling() {
        this.pollingTimer = setInterval(() => {
            if (!document.hidden && !this.isLoading) {
                console.log('🔄 Polling for new notifications...');
                this.loadNotifications();
            }
        }, this.pollingInterval);
    }

    stopPolling() {
        if (this.pollingTimer) {
            clearInterval(this.pollingTimer);
            this.pollingTimer = null;
        }
    }

    // Helper methods
    getNotificationIcon(type) {
        const icons = {
            'leave_application': 'fas fa-calendar-plus',
            'leave_approval': 'fas fa-check-circle',
            'leave_rejection': 'fas fa-times-circle',
            'appraisal_assigned': 'fas fa-chart-line',
            'appraisal_completed': 'fas fa-chart-bar',
            'system_alert': 'fas fa-info-circle',
            'appraisal_cycle': 'fas fa-sync-alt',
            'task_assigned': 'fas fa-tasks',
            'task_reminder': 'fas fa-clock',
            'financial_year': 'fas fa-calendar-alt',
            'password_expiry': 'fas fa-key',
            'profile_update': 'fas fa-user-edit',
            'financial_year_reminder': 'fas fa-calendar-alt',
            'quarterly_reports_reminder': 'fas fa-chart-pie'
        };
        return icons[type] || 'fas fa-bell';
    }

    getNotificationIconClass(type) {
        const classes = {
            'leave_application': 'icon-leave',
            'leave_approval': 'icon-approval',
            'leave_rejection': 'icon-rejection',
            'appraisal_assigned': 'icon-appraisal',
            'appraisal_completed': 'icon-appraisal',
            'system_alert': 'icon-system',
            'appraisal_cycle': 'icon-system',
            'task_assigned': 'icon-task',
            'task_reminder': 'icon-task',
            'financial_year': 'icon-system',
            'password_expiry': 'icon-system',
            'profile_update': 'icon-system',
            'financial_year_reminder': 'icon-financial',
            'quarterly_reports_reminder': 'icon-reports'
        };
        return classes[type] || 'icon-system';
    }

    formatTime(ts) {
        const t = new Date(ts), n = new Date(), d = n - t;
        const m = Math.floor(d / 60000), h = Math.floor(d / 3600000), days = Math.floor(d / 86400000);
        if (m < 1) return 'Just now';
        if (m < 60) return `${m}m ago`;
        if (h < 24) return `${h}h ago`;
        if (days < 7) return `${days}d ago`;
        return t.toLocaleDateString();
    }

    escapeHtml(unsafe) {
        return unsafe
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    window.notificationSystem = new MobileNotificationSystem();
});

// Handle visibility (pause polling when tab is hidden)
document.addEventListener('visibilitychange', () => {
    if (window.notificationSystem) {
        if (document.hidden) {
            window.notificationSystem.stopPolling();
        } else {
            window.notificationSystem.startPolling();
            // Refresh notifications when tab becomes visible
            setTimeout(() => window.notificationSystem.loadNotifications(), 1000);
        }
    }
});

// Enhanced Mobile Sidebar Toggle
function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    const body = document.body;

    if (sidebar) {
        sidebar.classList.toggle('mobile-open');
        if (overlay) overlay.style.display = sidebar.classList.contains('mobile-open') ? 'block' : 'none';
        body.style.overflow = sidebar.classList.contains('mobile-open') ? 'hidden' : '';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', (e) => { e.stopPropagation(); toggleSidebar(); });
    }

    const sidebarClose = document.querySelector('.sidebar-close');
    if (sidebarClose) {
        sidebarClose.addEventListener('click', (e) => { e.stopPropagation(); toggleSidebar(); });
    }

    document.querySelectorAll('.nav a').forEach(link => {
        link.addEventListener('click', () => {
            if (window.innerWidth <= 768) toggleSidebar();
        });
    });

    const overlay = document.querySelector('.sidebar-overlay');
    if (overlay) overlay.addEventListener('click', (e) => { e.stopPropagation(); toggleSidebar(); });

    document.addEventListener('click', (e) => {
        const sidebar = document.querySelector('.sidebar');
        const toggle = document.querySelector('.sidebar-toggle');
        const close = document.querySelector('.sidebar-close');
        if (sidebar?.classList.contains('mobile-open')) {
            const inside = sidebar.contains(e.target) || toggle?.contains(e.target) || close?.contains(e.target);
            if (!inside) toggleSidebar();
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && window.innerWidth <= 768) {
            const sidebar = document.querySelector('.sidebar');
            if (sidebar?.classList.contains('mobile-open')) toggleSidebar();
        }
    });

    window.addEventListener('resize', () => {
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.querySelector('.sidebar-overlay');
        if (window.innerWidth > 768 && sidebar?.classList.contains('mobile-open')) {
            sidebar.classList.remove('mobile-open');
            if (overlay) overlay.style.display = 'none';
            document.body.style.overflow = '';
        }
    });
});

// Session Checker
class SessionChecker {
    constructor() {
        this.checkInterval = 30000;
        this.lastSessionState = true;
        this.isChecking = false;
        this.init();
    }
    init() {
        this.checkSession();
        setInterval(() => this.checkSession(), this.checkInterval);
        document.addEventListener('visibilitychange', () => { if (!document.hidden) this.checkSession(); });
        window.addEventListener('focus', () => this.checkSession());
    }
    async checkSession() {
        if (this.isChecking) return;
        this.isChecking = true;
        try {
            const res = await fetch('auth_check.php', {
                headers: {'Cache-Control': 'no-cache', 'X-Requested-With': 'XMLHttpRequest'},
                credentials: 'same-origin'
            });
            if (res.ok) {
                const data = await res.json();
                if (!data.valid) this.handleSessionInvalid();
                else { this.lastSessionState = true; resetTimers(); }
            } else if (res.status >= 300 && res.status < 400) this.handleSessionInvalid();
        } catch (e) { console.warn('Session check error:', e); }
        finally { this.isChecking = false; }
    }
    handleSessionInvalid() {
        if (this.lastSessionState) {
            this.lastSessionState = false;
            clearTimeout(warningTimeout); clearTimeout(logoutTimeout);
            this.showSessionMessage('Session terminated. Redirecting...');
            setTimeout(() => {
                window.location.href = 'login.php?error=' + encodeURIComponent('Session terminated.');
            }, 3000);
        }
    }
    showSessionMessage(msg) {
        document.querySelectorAll('.session-notification').forEach(el => el.remove());
        const n = document.createElement('div');
        n.className = 'session-notification';
        n.style.cssText = `position:fixed;top:20px;right:20px;background:#f8d7da;color:#721c24;padding:15px 20px;border-radius:5px;border:1px solid #f5c6cb;z-index:10000;max-width:400px;box-shadow:0 4px 12px rgba(0,0,0,0.1);font-family:system-ui,sans-serif;`;
        n.innerHTML = `<strong>Session Terminated</strong><div style="margin-top:5px;font-size:14px;">${msg}</div>`;
        document.body.appendChild(n);
        setTimeout(() => n.remove(), 5000);
    }
    updateSessionActivity() {
        fetch('extend_session.php', { headers: {'X-Requested-With': 'XMLHttpRequest'}, credentials: 'same-origin' })
            .then(r => r.json()).then(d => { if (d.valid) resetTimers(); })
            .catch(() => {});
    }
}

let warningTimeout, logoutTimeout;
function resetTimers() {
    clearTimeout(warningTimeout); clearTimeout(logoutTimeout);
    warningTimeout = setTimeout(() => {
        if (confirm("Session expires in 1 min. Click OK to continue.")) {
            const sc = new SessionChecker();
            sc.updateSessionActivity();
        } else logoutUser();
    }, 14 * 60 * 1000);
    logoutTimeout = setTimeout(logoutUser, 15 * 60 * 1000);
}
function logoutUser() {
    window.location.href = 'logout.php?reason=inactivity';
}

document.addEventListener('DOMContentLoaded', () => {
    const sc = new SessionChecker();
    resetTimers();
    ['click','mousemove','keypress','scroll','touchstart','mousedown','keydown'].forEach(ev =>
        document.addEventListener(ev, resetTimers, { passive: true })
    );
    document.addEventListener('click', e => {
        if (e.target.closest('.btn-success') || e.target.closest('.btn-danger')) sc.updateSessionActivity();
    });
});

// Prevent form resubmission
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}
</script>
</body>
</html>
<?php ob_end_flush(); ?>