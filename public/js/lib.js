log = function(s) { console.log(s)}

goToPath = function(path) { 
  window.location.href = path;
}

nicePrompt = function(title,cb) {
  swal({
    title: title,
    html: '<p><input id="swal-prompt-input-field">',
  },
  function() {
    var val = $('#swal-prompt-input-field').val();
    if (val && cb) { cb(val); }    
  });
}

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

window.gulp = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

//console.log('defining onEnter');
function onInputEnter(el, cb) {
  $(el).keydown(e => {
    if ($(el).val() && (event.keyCode == 13)) {
      cb(el);
    }
  });
}


function setEndOfContenteditableHelper(id) {
  var elem = document.getElementById(id);
  setEndOfContenteditable(elem);
}

function setEndOfContenteditable(contentEditableElement)
{
  var range,selection;
  range = document.createRange();//Create a range (a range is a like the selection but invisible)
  range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
  range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
  selection = window.getSelection();//get the selection object (allows you to change selection)
  selection.removeAllRanges();//remove any selections already made
  selection.addRange(range);//make the range you have just created the visible selection
}

function uploadImg(file, cb) {
  var settings = {
    async: false, crossDomain: true, processData: false, contentType: false,
    type: 'POST', url: 'https://api.imgur.com/3/image',
    headers: {Authorization: 'Client-ID 3fe190ba92e9bed', Accept: 'application/json' },
    mimeType: 'multipart/form-data'
  };

  var formData = new FormData();
  formData.append("image", file);
  settings.data = formData;

  $.ajax(settings).done(cb) // link at response.data.link
}

function sortElemsList(containerSelector, itemSelector, data_attr) {
  var list = $(itemSelector);
  list.sort(function(a, b){
    var res =  ($(a).data(data_attr)-$(b).data(data_attr)) * -1;
    console.log(res);
    return res;
  });
  
  $(containerSelector).html(list);  
}