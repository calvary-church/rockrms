var selectEvents = (function() {
  //eliminate "click" event firing twice on mobile devices
	if ('ontouchstart' in document === true)
		return 'touchstart';
	else
		return 'click';
})();

function getCookie(cname) {
  var name = cname + "=";
  var decodedCookie = decodeURIComponent(document.cookie);
  var ca = decodedCookie.split(';');
  for(i = 0; i <ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

function generateSeriesContainers(){
	//console.log("Generating Series Containers...");
	var windowWidth = $(window).width();
	var allSeriesItems = $('#masterlist.sermon-grid .block-grid .series__item').clone();
	var clonedList = "<div id='clonedlist'></div>";
	$(clonedList).insertBefore($('#masterlist'));

	if (windowWidth >= 992) {
		for(var i = 0; i < allSeriesItems.length; i+=3) {
		  allSeriesItems.slice(i, i+3).appendTo($('#clonedlist')).wrapAll("<div class='sermon-grid generated'><div class='container'><div class='row'><div class='col-md-12'><div class='block-grid block-grid-xs-1 block-grid-sm-2 block-grid-md-3'></div></div></div></div></div>");
		}
	} else if (windowWidth >= 768) {
		for(i = 0; i < allSeriesItems.length; i+=2) {
		  allSeriesItems.slice(i, i+2).appendTo($('#clonedlist')).wrapAll("<div class='sermon-grid generated'><div class='container'><div class='row'><div class='col-md-12'><div class='block-grid block-grid-xs-1 block-grid-sm-2 block-grid-md-3'></div></div></div></div></div>");
		}
	}
	
	if (windowWidth >= 768) {
		$('#masterlist').hide();
		//$('.sermon-grid.generated').each(function(){
			//$(this).insertBefore($('#masterlist'));
		//});	
		$('.sermon-grid.generated .block-grid .series-container').each(function(){
			var parentContainer = $(this).closest('.sermon-grid');
			$(this).appendTo(parentContainer);
		});
	}
	
  $('.series-container .closer').on('click', function(e){
    e.preventDefault();
    var container = $(this).closest('.series-container');
    $(container).removeClass('open').hide();
		$('.series-opener').removeClass('open');		
		$('.series-container').removeClass('open');		
  });
  $('.series__item').on('click', '.series-opener', function(e){
		e.preventDefault();
		//window.console.log(e);
		$('.series-container').hide();
		var seriesblock = $(this).data('openseries');
    var opener = $(this);
		$('.series-opener').removeClass('open');		
		$('.series-container').removeClass('open').hide();		
		$(this).addClass('open');
		$("#"+seriesblock).addClass('open').slideDown();	
		
		// Make sure this.hash has a value before overriding default behavior
    if (seriesblock !== "") {
  
      // Using jQuery's animate() method to add smooth page scroll
      // The optional number (800) specifies the number of milliseconds it takes to scroll to the specified area
      $('html, body').animate({
        scrollTop: $(opener).offset().top - 10
      }, 800, function(){
  
      // Add hash (#) to URL when done scrolling (default click behavior)
      //window.location.hash = seriesblock;
      });
  
    } // End if        

	});

}

jQuery(function($){

  $("header").affix({
    offset: { 
	    top: 80
/*
      top: function(){
	      return $("header nav .page-menu").outerHeight(true);
      }
*/
    }
  });
  
  $('.navbar-collapse').on('show.bs.collapse', function() {
	  $('html').addClass('menu-open');
	});
  $('.navbar-collapse').on('hide.bs.collapse', function() {
	  $('html').removeClass('menu-open');
	});

	$.fn.select2.defaults.set( "theme", "bootstrap" );
  $('select.select2').select2({
    //allowClear: true,
    minimumResultsForSearch: Infinity
  });
  
  $('.panel-group .panel-title a').each(function(){
	  $(this).append('<svg class="cc-icon cc-icon-plus"><use xlink:href="#cc-icon-plus"></use></svg><svg class="cc-icon cc-icon-minus"><use xlink:href="#cc-icon-minus"></use></svg>');
  });
  
  $('#blog-filters select').on('change', function(){
		//var formGroup = $(this).parents('.filters');
		var url = window.location.pathname; // get page URL
		url += "?filter=" + $(this).attr("name"); // set page root URL
		$('#blog-filters  select').each(function(){
			url += "&" + $(this).attr("name") + "=" + $(this).val();
		});
		$('#blog-filters input').each(function(){
			if ($(this).prop( "checked" )) url += "&" + $(this).attr("name");
		});
		if (url) { // require a URL
		  window.location = url; // redirect
		}
		return false;
	});

	$( window ).load(function() {
		
		//console.log($('.sermon-grid').length);
		
		if ($('.sermon-grid').length) generateSeriesContainers();
		
	  var cname = 'EmergencyNotification';
	  if(getCookie('EmergencyNotification')!="hide" && $('#emergency-notification').length) {
	    $('#emergency-notification').slideDown();
	  }
	  if(!$('#emergency-notification').length) {
	    cvalue = null;
	    exdays = -1;
	    var d = new Date();
	    d.setTime(d.getTime() + (exdays*24*60*60*1000));
	    var expires = "expires="+d.toUTCString();
	    document.cookie = cname + "=" + cvalue + "; " + expires;
	  }
	  $('#emergency-notification .closer').on('click',function(e){
	    e.preventDefault();
	    cvalue = 'hide';
	    exdays = 1;
	    var d = new Date();
	    d.setTime(d.getTime() + (exdays*24*60*60*1000));
	    var expires = "expires="+d.toUTCString();
	    document.cookie = cname + "=" + cvalue + ";path=/; " + expires;
	    $('#emergency-notification').slideUp();  
	  });
	});
	
	$('#ipl_search a').on('click', function (e) {
		e.preventDefault();
	  $('#search-layer').toggleClass('active');
	  $('#search-layer .gsc-input').focus();
	});
	
	$('#search-layer').on({
	  focusout: function () {
	    $(this).data('timer', setTimeout(function () {
	      $(this).removeClass('active');
	      $('#ipl_search a').focus();
	    }.bind(this), 0));
	  },
		keydown: function (e) {
		  if (e.which === 27) {
		    $(this).removeClass('active');
	      $('#ipl_search a').focus();
		    e.preventDefault();
		  }
		},
	  focusin: function () {
	    clearTimeout($(this).data('timer'));
	  }
	});
	
	/*** IE/Edge fallbacks ***/
	if ( ! Modernizr.objectfit ) {
	  $('.billboard-inner > .item').each(function () {
	    var $container = $(this),
	        imgUrl = $container.find('img').prop('src');
	    if (imgUrl) {
	      $container
	        .css('backgroundImage', 'url(' + imgUrl + ')')
	        .addClass('compat-object-fit');
	    }  
	  });
	}

});

var resizeTimer;

$(window).on('resize', function(e) {

  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(function() {

    if ($('.sermon-grid').length) {
	    // Run code here, resizing has "stopped"
	    $('#clonedlist').remove();
			generateSeriesContainers();
    }
    
  }, 250);

});