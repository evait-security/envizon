import dt from 'datatables.net-bs5';
dt(window, $); // NOTE: this probably does the initializing for things like jQuery.fn.dataTableExt to be available
window.DataTable = dt; // just in case
