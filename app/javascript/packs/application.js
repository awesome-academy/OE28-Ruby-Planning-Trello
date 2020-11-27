require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('packs/toastr')
import 'bootstrap'
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
import $ from 'jquery'
global.$ = $
global.jQuery = $
require('jquery-ui')
require('packs/board_show')
require('packs/user_show')
require('packs/tag_edit')
require('packs/chat')
