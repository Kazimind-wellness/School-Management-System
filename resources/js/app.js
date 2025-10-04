import './bootstrap';
import Alpine from 'alpinejs';
import collapse from '@alpinejs/collapse';
import * as Turbo from '@hotwired/turbo';
// resources/js/app.js
import './bootstrap';
import './jquery.min.js';
import './bootstrap.js';
import './slick.js';
import './waypoints.js';
import './jquery.counterup.js';
import './jquery.mixitup.js';
import './jquery.fancybox.pack.js';
import './custom.js';

Alpine.plugin(collapse)
window.Alpine = Alpine;
document.addEventListener("livewire:load", function(event) {
    Turbo.start();

});

Alpine.start();