// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require swiper/swiper-bundle.min.js
//= require swiper.js

import "@hotwired/turbo-rails"
import "controllers"
import "@fortawesome/fontawesome-free"
import "custom/flash-window"
import Rails from '@rails/ujs';
Rails.start();
