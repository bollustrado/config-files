/*jslint browser: true, white: true*/
/*global $*/

'use strict';

var addSignature = function() {
    var $el = $(this);

    if ($el.attr('data-signature') !== 'true') {
        // remove "type here ..." message
        this.parentNode.firstChild.innerHTML = "";

        $el.html("\n<br>\n<br>Gruß David<br>\n<br>\n--<br>\nhttp://david-peter.de");

        // we do not want to add another signature to this email
        $el.attr('data-signature', 'true');
    }
};

$(document).ready(function() {
    $("button").click(function() {
        setTimeout(function() {
            // There might be several email windows. Each of
            // them has a textfield with id em-0, em-1, ..
            $("div[id^='em-']").one('click', addSignature);
        }, 100);
    });
});
