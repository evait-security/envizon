import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import './add_jquery';
import './add_data_table';
Rails.start()
Turbolinks.start()
ActiveStorage.start()

import * as bootstrap from 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'
import 'fontawesome-iconpicker/dist/js/fontawesome-iconpicker'

import Swal from 'sweetalert2'
import toastr from 'toastr/toastr';

window.Swal = Swal
window.bootstrap = bootstrap;
window.toastr = toastr;
window.Rails = Rails

// custom swal rails confirm

let __SkipConfirmation = false;

Rails.confirm = function (message, element) {
  if (__SkipConfirmation) {
    return true;
  }
  function onConfirm() {
    __SkipConfirmation = true
    element.click()
    __SkipConfirmation = false
  }
  Swal.fire({
    html: `${message}`,
    icon: 'question',
    customClass: {
      confirmButton: 'btn btn-success me-3',
      cancelButton: 'btn btn-secondary text-white'
    },
    buttonsStyling: false,
    showCancelButton: true,
    allowOutsideClick: false,
  }).then((result) => {
    if (result.isConfirmed) {
      onConfirm();
    }
  })
  return false;
};


import "./global.js"
import "./ip_address_datatable.js"
import "./ckeditor.js"
// import "./cable.js"
